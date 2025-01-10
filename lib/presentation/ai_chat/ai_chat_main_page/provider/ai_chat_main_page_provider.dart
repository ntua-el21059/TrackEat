import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../../../models/meal.dart';
import '../../../../services/meal_service.dart';
import '../../../../services/points_service.dart';
import '../models/ai_chat_main_page_model.dart';

const String apiKey = 'AIzaSyDe5fyQXDIfgZ1paU5Ax5HNj6gNyWA0MAA';
const String modelName = 'gemini-2.0-flash-exp';

const String _systemPrompt = '''
You are TrackEat AI, a witty and helpful food logging assistant. Your primary purpose is to help users track their meals and nutrition.

When users ask questions:
1. If it's food-related: Provide helpful, accurate information about nutrition, meal logging, and healthy eating habits.
2. If it's NOT food-related: Respond with a clever, food-themed redirection.
Easter Eggs:
1. If user asks "who is chris.tsourv": "chris.tsourv loves to eat and code so he created me!

Always maintain a friendly, witty tone while guiding users back to food-related discussions.
''';

class AiChatMainProvider extends ChangeNotifier {
  final MealService _mealService = MealService();
  final PointsService _pointsService = PointsService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController messageController = TextEditingController();
  AiChatMainModel aiChatMainModelObj = AiChatMainModel();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;
  bool showTrackDialog = false;
  Map<String, dynamic>? lastNutritionData;
  double slideProgress = 0.0;
  bool showMealTypeSelection = false;
  bool showTrackingSuccess = false;
  String? selectedMealType;
  String? _previousFood;

  final GenerativeModel _model = GenerativeModel(
    model: modelName,
    apiKey: apiKey,
  );

  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  Map<String, String>? _userProvidedNutrition;

  AiChatMainProvider() {
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
  }

  Future<void> pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setSelectedImage(image);
    }
  }

  void setSelectedImage(XFile image) {
    selectedImage = image;
    notifyListeners();
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  Future<bool> _isNegativeResponse(String message) async {
    final negativePrompt = '''
    Is this a negative response? Consider variations like:
    - "no"
    - "nope"
    - "nah"
    - "not really"
    - "don't want to"
    
    Respond with only "true" or "false":
    Message: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(negativePrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting negative response: $e');
      return false;
    }
  }

  Future<String> _getFoodInfo(String message, {bool isDirectCommand = false, bool isEatingStatement = false}) async {
    if (isDirectCommand || isEatingStatement) {
      // For direct commands and eating statements, skip food facts and go straight to nutrition questions
      final askForNutritionPrompt = '''
      Ask for nutritional information in a friendly way. Include these points:
      - Serving size
      - Calories
      - Protein (g)
      - Carbs (g)
      - Fat (g)
      
      Important:
      1. Make it clear that providing the information is optional
      2. Mention that you'll make your best estimate if they don't know
      3. Keep the tone friendly and conversational
      4. Ask directly without any meta-commentary or self-talk
      5. DO NOT mention how you'll phrase the question or your thought process
      
      Example good response:
      "Can you tell me any nutritional information about this? Like serving size, calories, protein, carbs, or fat? Don't worry if you're not sure - I can estimate!"
      
      Example bad response:
      "Okay, I'm ready to ask for nutritional info. Here's how I'll phrase it: Can you tell me..."
      ''';

      final response = await _model.generateContent([Content.text(askForNutritionPrompt)]);
      return response.text?.trim() ?? "Can you tell me any nutritional information about this? Don't worry if you're not sure - I can estimate!";
    }

    // For simple food mentions, provide witty info and ask if they want to log it
    final infoPrompt = '''
    You are TrackEat AI. Share 2-3 interesting, fun, or witty facts about this food. Be creative and engaging!
    Then ask if they'd like to log it. Use variations like:
    - "Want me to add this to your food log?"
    - "Should I track this for you?"
    - "Would you like me to log this in your diary?"
    - "Shall we add this to today's meals?"
    
    Example response:
    "🍔 Did you know the Big Mac was created in 1967 by Jim Delligatti? And here's a mind-bender: the average person eats 17 Big Macs per year in the US! 
    
    Want me to add this to your food log?"
    
    Food: "${message}"
    ''';

    try {
      final response = await _model.generateContent([Content.text(infoPrompt)]);
      return response.text?.trim() ?? "Would you like me to log this for you?";
    } catch (e) {
      print('Error getting food info: $e');
      return "Would you like me to log this for you?";
    }
  }

  Future<Map<String, dynamic>> _getNutritionFromText(String message) async {
    final nutritionPrompt = '''
    Extract or estimate nutritional information from this text. If any values are missing or unclear, make a reasonable estimate based on the food description. Respond with ONLY a valid JSON object in this format:
    {
      "food": "name of the food",
      "serving_size": "estimated serving",
      "calories": 123,
      "protein": 12,
      "carbs": 34,
      "fat": 56
    }
    
    Text: "$message"
    ${_userProvidedNutrition != null ? "User provided values: ${json.encode(_userProvidedNutrition)}" : ""}
    ''';

    try {
      final response = await _model.generateContent([Content.text(nutritionPrompt)]);
      if (response.text != null) {
        String cleanedResponse = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        return json.decode(cleanedResponse);
      }
    } catch (e) {
      print('Error getting nutrition from text: $e');
    }
    return {};
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage == null) return;

    try {
      isLoading = true;
      notifyListeners();

      // Clear message box and close keyboard
      messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      // Add user message to chat once
      messages.add({
        'role': 'user',
        'content': message,
      });
      notifyListeners();
      if (onMessageAdded != null) onMessageAdded!();

      // Analyze the message
      final analysis = await _analyzeMessage(message, previousFood: _previousFood);

      // If it's just a food mention without tracking intent, provide info and ask if they want to log it
      if (analysis['is_food_mention'] == true && !analysis['is_tracking_intent']) {
        _previousFood = analysis['food_name']; // Store the food name for later
        final foodInfo = await _getFoodInfo(analysis['food_name'], isDirectCommand: false, isEatingStatement: false);
        messages.add({
          'role': 'assistant',
          'content': foodInfo,
        });
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();
        return;
      }

      // If tracking dialog is visible, check for food specification or modification
      if (showTrackDialog && lastNutritionData != null) {
        if (analysis['is_specifying_food'] == true && analysis['combined_food_name'] != null) {
          // Get nutrition data for the specified food
          final nutritionData = await _getNutritionFromText(analysis['combined_food_name']);
          lastNutritionData = nutritionData;

          String formattedResponse =
              'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
              '🍽️ Serving Size: ${nutritionData['serving_size']}\n'
              '🔥 Calories: ${nutritionData['calories']}\n'
              '💪 Protein: ${nutritionData['protein']}g\n'
              '🌾 Carbs: ${nutritionData['carbs']}g\n'
              '🥑 Fat: ${nutritionData['fat']}g';

          messages.add({
            'role': 'assistant',
            'content': formattedResponse,
          });
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
          return;
        } else {
          // Handle as modification request
          // ... (keep existing modification handling code)
        }
      }

      // Handle new tracking intent
      if (analysis['is_tracking_intent'] == true) {
        _previousFood = analysis['food_name']; // Store the food name
        
        if (analysis['is_common_food'] == true) {
          // Get nutrition data directly and show track dialog
          final nutritionData = await _getNutritionFromText(analysis['food_name']);
          
          // Apply quantity and size modifiers
          if (nutritionData.isNotEmpty) {
            final quantity = analysis['quantity'] ?? 1;
            final sizeModifier = analysis['size_modifier'];
            
            double multiplier = 1.0;
            if (sizeModifier == 'small') multiplier = 0.7;
            if (sizeModifier == 'large') multiplier = 1.3;
            
            nutritionData['calories'] = (nutritionData['calories'] as num) * quantity * multiplier;
            nutritionData['protein'] = (nutritionData['protein'] as num) * quantity * multiplier;
            nutritionData['carbs'] = (nutritionData['carbs'] as num) * quantity * multiplier;
            nutritionData['fat'] = (nutritionData['fat'] as num) * quantity * multiplier;
            
            String sizePrefix = sizeModifier != null ? "${sizeModifier} " : "";
            nutritionData['serving_size'] = "${quantity}x ${sizePrefix}${nutritionData['serving_size']}";
            
            lastNutritionData = nutritionData;

            String formattedResponse =
                'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
                '🍽️ Serving Size: ${nutritionData['serving_size']}\n'
                '🔥 Calories: ${nutritionData['calories']}\n'
                '💪 Protein: ${nutritionData['protein']}g\n'
                '🌾 Carbs: ${nutritionData['carbs']}g\n'
                '🥑 Fat: ${nutritionData['fat']}g';

            messages.add({
              'role': 'assistant',
              'content': formattedResponse,
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();

            showTrackDialog = true;
            _userProvidedNutrition = null;
          }
        } else {
          // For non-common foods, ask for nutritional information
          final foodInfo = await _getFoodInfo(analysis['food_name'], 
            isDirectCommand: analysis['is_direct_command'] == true,
            isEatingStatement: analysis['is_eating_statement'] == true);
          messages.add({
            'role': 'assistant',
            'content': foodInfo,
          });
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
          
          _userProvidedNutrition = null;
        }
        return;
      }

      // Check if user doesn't know nutritional info or says no
      if (await _isDontKnowResponse(message) || await _isNegativeResponse(message)) {
        // Get nutrition data for the previous food
        final nutritionData = await _getNutritionFromText(_previousFood ?? message);
        lastNutritionData = nutritionData;

        String formattedResponse =
            'No problem! I\'ll estimate the nutritional values:\n\n' +
            'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
            '🍽️ Serving Size: ${nutritionData['serving_size']}\n'
            '🔥 Calories: ${nutritionData['calories']}\n'
            '💪 Protein: ${nutritionData['protein']}g\n'
            '🌾 Carbs: ${nutritionData['carbs']}g\n'
            '🥑 Fat: ${nutritionData['fat']}g';

        messages.add({
          'role': 'assistant',
          'content': formattedResponse,
        });
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();

        showTrackDialog = true;
        _userProvidedNutrition = null;
        return;
      }

      // If not specifying food or saying idk, continue with normal flow
      // Check if user wants to proceed with logging
      if (analysis['is_affirmative'] == true) {
        // Get nutrition data directly and show track dialog
        final nutritionData = await _getNutritionFromText(_previousFood ?? message);
        lastNutritionData = nutritionData;

        String formattedResponse =
            'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
            '🍽️ Serving Size: ${nutritionData['serving_size']}\n'
            '🔥 Calories: ${nutritionData['calories']}\n'
            '💪 Protein: ${nutritionData['protein']}g\n'
            '🌾 Carbs: ${nutritionData['carbs']}g\n'
            '🥑 Fat: ${nutritionData['fat']}g';

        messages.add({
          'role': 'assistant',
          'content': formattedResponse,
        });
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();

        showTrackDialog = true;
        _userProvidedNutrition = null;
      } else {
        // For any non-yes response, continue normal conversation
        _chat = _model.startChat(history: [
          Content.text(_systemPrompt),
          ...messages.map((msg) => Content.text(msg['content']!)),
        ]);

        final response = await _chat.sendMessage(Content.text(message));
        if (response.text != null) {
          messages.add({
            'role': 'assistant',
            'content': response.text!.trim(),
          });
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
        }
      }
    } catch (e, stackTrace) {
      print('Error sending message: $e');
      print('Stacktrace: $stackTrace');
      messages.add({
        'role': 'assistant',
        'content': 'Sorry, I encountered an error. Please try again.',
      });
      notifyListeners();
      if (onMessageAdded != null) onMessageAdded!();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void trackNutrition() {
    if (lastNutritionData != null) {
      // TODO: Implement tracking logic with selectedMealType
      showTrackingSuccess = true;
      notifyListeners();

      // Auto-dismiss after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        showTrackDialog = false;
        showMealTypeSelection = false;
        showTrackingSuccess = false;
        selectedMealType = null;
        notifyListeners();
      });
    }
  }

  void setTrackDialogState(bool state) {
    showTrackDialog = state;
    if (!state) {
      // Reset all states when canceling
      showMealTypeSelection = false;
      showTrackingSuccess = false;
      slideProgress = 0.0;
      selectedMealType = null;
      lastNutritionData = null;
      _userProvidedNutrition = null;
      _previousFood = null;
    }
    notifyListeners();
  }

  void updateSlideProgress(double progress) {
    // Snap to complete when progress is close to 1.0
    if (progress > 0.85) {
      slideProgress = 1.0;
      showMealTypeSelection = true;
    } else {
      slideProgress = progress.clamp(0.0, 1.0);
    }
    notifyListeners();
  }

  void resetSlideProgress() {
    slideProgress = 0.0;
    showMealTypeSelection = false;
    selectedMealType = null;
    notifyListeners();
  }

  void selectMealType(String mealType) async {
    if (lastNutritionData == null || _auth.currentUser == null) return;

    selectedMealType = mealType;
    notifyListeners();

    try {
      // Create a new meal object
      final meal = Meal(
        id: '', // Will be set by Firestore
        userEmail: _auth.currentUser!.email!,
        name: lastNutritionData!['food'],
        mealType: mealType.toLowerCase(),
        calories: (lastNutritionData!['calories'] as num).round(),
        servingSize: _parseServingSize(lastNutritionData!['serving_size']),
        macros: {
          'protein': (lastNutritionData!['protein'] as num).toDouble(),
          'fats': (lastNutritionData!['fat'] as num).toDouble(),
          'carbs': (lastNutritionData!['carbs'] as num).toDouble(),
        },
        date: DateTime.now(),
      );

      // Save to Firebase
      await _mealService.addMeal(meal);

      // Add points for logging a meal
      await _pointsService.addMealPoints();

      // Show success message
      showTrackingSuccess = true;
      notifyListeners();

      // Auto-dismiss after 2 seconds and reset all states
      Future.delayed(Duration(seconds: 2), () {
        // Reset all tracking-related states
        showTrackDialog = false;
        showMealTypeSelection = false;
        showTrackingSuccess = false;
        selectedMealType = null;
        lastNutritionData = null;
        _userProvidedNutrition = null;
        _previousFood = null;
        slideProgress = 0.0;
        notifyListeners();
      });
    } catch (e) {
      print('Error saving meal: $e');
      // Reset states on error
      showTrackDialog = false;
      showMealTypeSelection = false;
      showTrackingSuccess = false;
      selectedMealType = null;
      lastNutritionData = null;
      _userProvidedNutrition = null;
      _previousFood = null;
      slideProgress = 0.0;
      notifyListeners();
    }
  }

  // Helper method to parse serving size
  double _parseServingSize(String servingSize) {
    // Extract numbers from the string
    final numbers = RegExp(r'[0-9]+\.?[0-9]*').firstMatch(servingSize);
    if (numbers != null) {
      return double.tryParse(numbers.group(0)!) ?? 100.0;
    }
    // If no numbers found, return default serving size
    return 100.0;
  }

  Future<bool> _isDontKnowResponse(String message) async {
    final dontKnowPrompt = '''
    Does this message indicate the user doesn't know or is unsure? Consider variations like:
    - "idk"
    - "I don't know"
    - "not sure"
    - "no idea"
    - "dunno"
    - "🤷‍♂️" or "🤷‍♀️"
    
    Respond with only "true" or "false":
    Message: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(dontKnowPrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting don\'t know response: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> _analyzeMessage(String message, {String? previousFood}) async {
    final analysisPrompt = '''
    Analyze this message and respond with ONLY a JSON object containing all the following information:
    {
      "is_tracking_intent": true/false,    // Does the message indicate intent to track food? (e.g., "log", "track", "ate", "had")
      "is_direct_command": true/false,     // Is it a direct command to log food? (e.g., "log a big mac")
      "is_eating_statement": true/false,   // Is it a statement about eating food? (e.g., "I ate", "just had")
      "is_food_mention": true/false,       // Is this just mentioning a food without tracking intent? (e.g., "big mac", "apple")
      "is_common_food": true/false,        // Is the food mentioned a common/well-known item?
      "is_affirmative": true/false,        // Is this a "yes" response? (e.g., "yes", "sure", "okay", "yep")
      "food_name": "extracted food name or null",
      "quantity": number,                  // Extract any quantity mentioned, default to 1
      "size_modifier": "small/medium/large/null", // Extract any size mentioned
      "is_specifying_food": true/false,    // Is this specifying/modifying a previous food?
      "specification_type": "name/size/attribute/null", // What type of specification is it?
      "combined_food_name": "combined name or null"  // If specifying, combine with previous food
    }

    Examples:
    Message: "log a big mac"
    Previous food: null
    {"is_tracking_intent": true, "is_direct_command": true, "is_eating_statement": false, "is_food_mention": false, "is_common_food": true, "is_affirmative": false, "food_name": "big mac", "quantity": 1, "size_modifier": null, "is_specifying_food": false, "specification_type": null, "combined_food_name": null}

    Message: "I ate 3 small apples"
    Previous food: null
    {"is_tracking_intent": true, "is_direct_command": false, "is_eating_statement": true, "is_food_mention": false, "is_common_food": true, "is_affirmative": false, "food_name": "apple", "quantity": 3, "size_modifier": "small", "is_specifying_food": false, "specification_type": null, "combined_food_name": null}

    Message: "big mac"
    Previous food: null
    {"is_tracking_intent": false, "is_direct_command": false, "is_eating_statement": false, "is_food_mention": true, "is_common_food": true, "is_affirmative": false, "food_name": "big mac", "quantity": 1, "size_modifier": null, "is_specifying_food": false, "specification_type": null, "combined_food_name": null}

    Message: "yes"
    Previous food: "big mac"
    {"is_tracking_intent": false, "is_direct_command": false, "is_eating_statement": false, "is_food_mention": false, "is_common_food": false, "is_affirmative": true, "food_name": null, "quantity": 1, "size_modifier": null, "is_specifying_food": false, "specification_type": null, "combined_food_name": null}

    Message: "sure, log it"
    Previous food: "apple"
    {"is_tracking_intent": false, "is_direct_command": false, "is_eating_statement": false, "is_food_mention": false, "is_common_food": false, "is_affirmative": true, "food_name": null, "quantity": 1, "size_modifier": null, "is_specifying_food": false, "specification_type": null, "combined_food_name": null}

    Message: "it was a BLT"
    Previous food: "sandwich"
    {"is_tracking_intent": false, "is_direct_command": false, "is_eating_statement": false, "is_food_mention": false, "is_common_food": true, "is_affirmative": false, "food_name": "BLT", "quantity": 1, "size_modifier": null, "is_specifying_food": true, "specification_type": "name", "combined_food_name": "BLT"}

    Message: "${message}"
    ${previousFood != null ? 'Previous food: "$previousFood"' : 'Previous food: null'}
    ''';

    try {
      final response = await _model.generateContent([Content.text(analysisPrompt)]);
      if (response.text != null) {
        String cleanedResponse = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        return json.decode(cleanedResponse);
      }
    } catch (e) {
      print('Error analyzing message: $e');
    }
    return {};
  }

  @override
  void dispose() {
    // Reset all states and flows
    showTrackDialog = false;
    showMealTypeSelection = false;
    showTrackingSuccess = false;
    slideProgress = 0.0;
    selectedMealType = null;
    lastNutritionData = null;
    _userProvidedNutrition = null;
    _previousFood = null;
    selectedImage = null;
    isLoading = false;
    messages.clear();
    
    // Dispose controllers
    messageController.dispose();
    super.dispose();
  }
}

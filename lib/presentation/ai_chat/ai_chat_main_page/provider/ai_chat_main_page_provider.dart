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

  bool _isTrackingFlow = false;
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

  Future<bool> _isTrackingIntent(String message) async {
    final trackingPrompt = '''
    Analyze if this message indicates a user's intent to track food. Consider:
    1. Direct commands ("log a big mac", "add an apple")
    2. Indirect tracking requests ("can you add this", "put this in my log")
    3. Context-dependent phrases ("write this down", "save this")
    4. Tracking-related verbs (log, track, add, save, write, put, record)

    Important: If the message doesn't specify WHAT food to track (e.g., "log this", "save it"), respond with "false".
    Only respond "true" if there's a clear food item mentioned.

    Respond with only "true" or "false":
    Message: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(trackingPrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting tracking intent: $e');
      return false;
    }
  }

  Future<bool> _isDirectLoggingCommand(String message) async {
    final directCommandPrompt = '''
    Does this message directly command to log/track/add food (e.g. "log a big mac", "add an apple", "track my sandwich")? 
    Note: If it's just "log it" or "track it" without specifying what food, respond with "false".
    Respond with only "true" or "false":
    Message: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(directCommandPrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting direct command: $e');
      return false;
    }
  }

  Future<String> _getFoodInfo(String message, {bool isDirectCommand = false}) async {
    final infoPrompt = '''
    You are TrackEat AI. Share 2-3 interesting or fun facts about this food in a witty way.
    Keep it concise and engaging. ${!isDirectCommand ? 'End with "Would you like me to log this for you?"' : ''}
    
    Food: "$message"
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

  Future<bool> _isCommonFood(String message) async {
    final commonFoodPrompt = '''
    Is this a well-known food item with standard nutritional values (like Big Mac, apple, banana, etc.)? Respond with only "true" or "false":
    Food: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(commonFoodPrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting common food: $e');
      return false;
    }
  }

  Future<bool> _isAffirmativeResponse(String message) async {
    final affirmativePrompt = '''
    In the context of food tracking, determine if this is an affirmative response. Consider:
    1. Direct "yes" responses in any form (yes, yup, sure, etc.)
    2. Tracking commands (log it, track it, add it, etc.)
    3. Context-aware responses that imply agreement to proceed
    
    Respond with only "true" or "false":
    Response: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(affirmativePrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting affirmative response: $e');
      return false;
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage == null) return;

    try {
      isLoading = true;
      notifyListeners();

      // Add user message to chat once
      messages.add({
        'role': 'user',
        'content': message,
      });
      notifyListeners();
      if (onMessageAdded != null) onMessageAdded!();

      // Handle tracking requests without food context
      if (!_isTrackingFlow && await _model.generateContent([Content.text('''
        Does this message indicate a desire to track food but WITHOUT specifying what food (e.g. "log this", "save it", "can you add this")? 
        Respond with only "true" or "false":
        Message: "$message"
        ''')]).then((response) => response.text?.trim().toLowerCase() == 'true')) {
        
        messages.add({
          'role': 'assistant',
          'content': "I'll help you track your food! What would you like to log?",
        });
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();
        isLoading = false;
        notifyListeners();
        return;
      }

      // If tracking dialog is visible, treat message as modification request
      if (showTrackDialog && lastNutritionData != null) {
        // Update nutrition based on modification request
        final modificationPrompt = '''
        Current food data:
        ${json.encode(lastNutritionData)}
        
        User modification request: "${message}"
        
        Update the nutritional values based on the user's request. Important rules:
        1. If calories change, adjust protein, carbs, and fat proportionally
        2. Maintain the original macro ratio
        3. Remember: 1g protein = 4 calories, 1g carbs = 4 calories, 1g fat = 9 calories
        4. Round numbers reasonably for usability
        
        Respond with ONLY a valid JSON object with the modified values:
        {
          "food": "name of the food",
          "serving_size": "detected serving size",
          "calories": 123,
          "protein": 12,
          "carbs": 34,
          "fat": 56
        }
        ''';

        final response = await _model.generateContent([Content.text(modificationPrompt)]);
        if (response.text != null) {
          try {
            String cleanedResponse = response.text!
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();

            Map<String, dynamic> updatedNutritionData = jsonDecode(cleanedResponse);
            lastNutritionData = updatedNutritionData;

            String formattedResponse =
                'Updated values:\n' +
                'Food: ${updatedNutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n' +
                '🍽️ Serving Size: ${updatedNutritionData['serving_size']}\n' +
                '🔥 Calories: ${updatedNutritionData['calories']}\n' +
                '💪 Protein: ${updatedNutritionData['protein']}g\n' +
                '🌾 Carbs: ${updatedNutritionData['carbs']}g\n' +
                '🥑 Fat: ${updatedNutritionData['fat']}g';

            messages.add({
              'role': 'assistant',
              'content': formattedResponse,
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();
          } catch (e) {
            print('Error updating nutrition data: $e');
            messages.add({
              'role': 'assistant',
              'content': 'Sorry, I had trouble updating the nutritional information. Please try again with clearer instructions.',
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();
          }
        }
        isLoading = false;
        notifyListeners();
        return;
      }

      if (selectedImage != null) {
        final userText = message.trim();
        final imageMessage =
            '📸 Image${userText.isNotEmpty ? "\nUser note: $userText" : ""}\n${selectedImage!.path}';

        // Replace the text message with the image message
        messages.removeLast();
        messages.add({
          'role': 'user',
          'content': imageMessage,
        });
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();

        // Prepare image analysis prompt
        final imagePrompt =
            """You are a nutrition analysis assistant. Look at this food image and respond ONLY with a valid JSON object in exactly this format, with no additional text or markdown:
{
  "food": "name of the food",
  "serving_size": "detected serving size",
  "calories": 123,
  "protein": 12,
  "carbs": 34,
  "fat": 56
}
${userText.isNotEmpty ? "\nNote from user: $userText\nPlease consider this information when analyzing the image." : ""}
Important: Respond with ONLY the JSON object, no other text.""";

        // Send image to Gemini
        final content = Content.multi([
          TextPart(imagePrompt),
          DataPart('image/jpeg', await selectedImage!.readAsBytes()),
        ]);

        final response = await _model.generateContent([content]);
        final responseText = response.text;

        if (responseText != null) {
          try {
            // Clean and parse JSON response
            String cleanedResponse = responseText
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();

            Map<String, dynamic> nutritionData = jsonDecode(cleanedResponse);
            lastNutritionData = nutritionData;

            String formattedResponse =
                'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
                '🍽️ Serving Size: ${nutritionData['serving_size']}\n'
                '🔥 Calories: ${nutritionData['calories']}\n'
                '💪 Protein: ${nutritionData['protein']}g\n'
                '🌾 Carbs: ${nutritionData['carbs']}g\n'
                '🥑 Fat: ${nutritionData['fat']}g';

            // Add the formatted response to messages
            messages.add({
              'role': 'assistant',
              'content': formattedResponse,
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();

            // Add the image analysis to chat history for context
            _chat = _model.startChat(history: [
              Content.text(_systemPrompt),
              ...messages.map((msg) => Content.text(msg['content']!)),
            ]);

            // Show track dialog after response
            showTrackDialog = true;
          } catch (e) {
            print('Error parsing nutrition data: $e');
            messages.add({
              'role': 'assistant',
              'content':
                  'Sorry, I had trouble analyzing the nutritional information. Please try again.',
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();
          }
        }
      } else {
        // Check if this is a tracking intent
        if (!_isTrackingFlow && await _isTrackingIntent(message)) {
          _previousFood = message; // Store the food name
          final isDirectCommand = await _isDirectLoggingCommand(message);
          
          if (isDirectCommand) {
            // Extract the food name from the command
            final foodNamePrompt = '''
            Extract just the food name from this logging command. Respond with ONLY the food name:
            Command: "$message"
            ''';
            final foodResponse = await _model.generateContent([Content.text(foodNamePrompt)]);
            final foodName = foodResponse.text?.trim() ?? message;
            _previousFood = foodName;

            // If it's a direct command and common food, go straight to tracking
            if (await _isCommonFood(foodName)) {
              final nutritionData = await _getNutritionFromText(foodName);
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
              _isTrackingFlow = false;
              _userProvidedNutrition = null;
            } else {
              // For non-common foods, still show facts but go straight to nutrition questions
              final foodInfo = await _getFoodInfo(foodName, isDirectCommand: true);
              messages.add({
                'role': 'assistant',
                'content': foodInfo,
              });
              notifyListeners();
              if (onMessageAdded != null) onMessageAdded!();

              // Ask for nutritional information
              final askForNutritionPrompt = '''
              Ask them if they can provide any of these values (but make it clear it's optional):
              - Serving size
              - Calories
              - Protein (g)
              - Carbs (g)
              - Fat (g)
              
              If they can't provide some or all values, let them know you'll make the best estimate.
              ''';

              final response = await _model.generateContent([Content.text(askForNutritionPrompt)]);
              if (response.text != null) {
                messages.add({
                  'role': 'assistant',
                  'content': response.text!.trim(),
                });
                notifyListeners();
                if (onMessageAdded != null) onMessageAdded!();
              }
            }
          } else {
            // Regular flow - show facts and ask for confirmation
            final foodInfo = await _getFoodInfo(message, isDirectCommand: false);
            messages.add({
              'role': 'assistant',
              'content': foodInfo,
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();
            
            _isTrackingFlow = true;
          }
        } else if (_isTrackingFlow) {
          // Check if user wants to proceed with logging
          if (await _isAffirmativeResponse(message)) {
            // Check if it's a common food
            if (await _isCommonFood(_previousFood ?? message)) {
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
              _isTrackingFlow = false;
              _userProvidedNutrition = null;
            } else {
              // Ask for nutritional information for non-common foods
              final askForNutritionPrompt = '''
              Ask them if they can provide any of these values (but make it clear it's optional):
              - Serving size
              - Calories
              - Protein (g)
              - Carbs (g)
              - Fat (g)
              
              If they can't provide some or all values, let them know you'll make the best estimate.
              ''';

              final response = await _model.generateContent([Content.text(askForNutritionPrompt)]);
              if (response.text != null) {
                messages.add({
                  'role': 'assistant',
                  'content': response.text!.trim(),
                });
                notifyListeners();
                if (onMessageAdded != null) onMessageAdded!();
              }
            }
          } else {
            // For any non-yes response, continue normal conversation
            _isTrackingFlow = false;
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
        } else {
          // Normal conversation flow
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
      }

      messageController.clear();
      removeImage();
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
      _isTrackingFlow = false;
      _userProvidedNutrition = null;
      _previousFood = null;
    }
    notifyListeners();
  }

  void updateSlideProgress(double progress) {
    slideProgress = progress.clamp(0.0, 1.0);
    notifyListeners();
    if (slideProgress >= 1.0) {
      showMealTypeSelection = true;
      notifyListeners();
    }
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
        calories: lastNutritionData!['calories'],
        servingSize: _parseServingSize(lastNutritionData!['serving_size']),
        macros: {
          'protein': lastNutritionData!['protein'].toDouble(),
          'fats': lastNutritionData!['fat'].toDouble(),
          'carbs': lastNutritionData!['carbs'].toDouble(),
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

      // Auto-dismiss after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        showTrackDialog = false;
        showMealTypeSelection = false;
        showTrackingSuccess = false;
        selectedMealType = null;
        notifyListeners();
      });
    } catch (e) {
      print('Error saving meal: $e');
      // Reset states on error
      showTrackDialog = false;
      showMealTypeSelection = false;
      showTrackingSuccess = false;
      selectedMealType = null;
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

  @override
  void dispose() {
    // Reset all states and flows
    showTrackDialog = false;
    showMealTypeSelection = false;
    showTrackingSuccess = false;
    slideProgress = 0.0;
    selectedMealType = null;
    lastNutritionData = null;
    _isTrackingFlow = false;
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

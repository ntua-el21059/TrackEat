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
    5. Statements about eating food ("I ate", "I had", "I consumed", "just ate", "just had")
    6. Past tense food consumption ("ate a sandwich", "had some pasta")

    Important: 
    1. If the message doesn't specify WHAT food to track (e.g., "log this", "save it"), respond with "false"
    2. Only respond "true" if there's a clear food item mentioned
    3. Statements about eating specific food should be considered as tracking intents

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
    Does this message contain a direct command to log/track/add food (e.g. "log a big mac", "add an apple", "track my sandwich")?
    Note: Statements about eating (e.g. "I ate a sandwich") should return false.
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

  Future<bool> _isEatingStatement(String message) async {
    final eatingPrompt = '''
    Does this message state that food was eaten (e.g. "I ate a sandwich", "just had pasta", "I had some pizza", "I ate 10 big macs")?
    Note: Direct commands (e.g. "log a sandwich") should return false.
    Respond with only "true" or "false":
    Message: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(eatingPrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting eating statement: $e');
      return false;
    }
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

    // Original food facts for non-direct interactions
    final infoPrompt = '''
    You are TrackEat AI. Share 2-3 interesting or fun facts about this food in a witty way.
    Keep it concise and engaging. End with "Would you like me to log this for you?"
    
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
    Is this a well-known food item with standard nutritional values (like Big Mac, apple, banana, pizza slice, etc.)? Consider common fast food items, fruits, and basic meals.
    
    Examples of common foods:
    - Big Mac
    - Quarter Pounder
    - Apple
    - Banana
    - Pizza slice
    - Chicken nugget
    
    Respond with only "true" or "false":
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

  Future<bool> _isSpecifyingFood(String message, String previousFood) async {
    final specifyingFoodPrompt = '''
    Determine if this message is specifying or modifying a food type rather than providing nutritional information.
    Previous food: "${previousFood}"
    Message: "${message}"
    
    Examples of food specification:
    - Previous: "sandwich" Message: "it was a BLT" -> true
    - Previous: "pasta" Message: "spaghetti bolognese" -> true
    - Previous: "chicken" Message: "grilled chicken breast" -> true
    - Previous: "burger" Message: "it was a quarter pounder" -> true
    - Previous: "apple" Message: "it was green" -> true
    - Previous: "apple" Message: "red delicious" -> true
    - Previous: "banana" Message: "it was ripe" -> true
    
    Examples of nutrition info (should return false):
    - "about 500 calories"
    - "100g serving"
    - "20g of protein"
    - "medium size"
    
    Important: Consider color, variety, and state (ripe, cooked, etc.) as food specifications when they help identify a specific type of food.
    
    Respond with only "true" or "false":
    ''';

    try {
      final response = await _model.generateContent([Content.text(specifyingFoodPrompt)]);
      return response.text?.trim().toLowerCase() == 'true';
    } catch (e) {
      print('Error detecting food specification: $e');
      return false;
    }
  }

  Future<String?> _extractSpecifiedFood(String message) async {
    final extractFoodPrompt = '''
    Extract the complete food name including any specifications (color, variety, state, etc.) from this message.
    If the message only contains a specification (like "it was green"), respond with "null".
    
    Examples:
    - "it was a BLT" -> "BLT"
    - "grilled chicken breast" -> "grilled chicken breast"
    - "it was green" -> "null"
    - "red delicious" -> "null"
    
    Respond with ONLY the food name or "null":
    Message: "${message}"
    ''';

    try {
      final response = await _model.generateContent([Content.text(extractFoodPrompt)]);
      final extractedFood = response.text?.trim();
      if (extractedFood == "null") {
        return null;
      }
      return extractedFood;
    } catch (e) {
      print('Error extracting specified food: $e');
      return null;
    }
  }

  Future<String> _combineWithPreviousFood(String specification, String previousFood) async {
    final combinePrompt = '''
    Combine the previous food with its specification to create a complete food name.
    Previous food: "${previousFood}"
    Specification: "${specification}"
    
    Examples:
    - Previous: "apple" + "it was green" -> "green apple"
    - Previous: "apple" + "red delicious" -> "red delicious apple"
    - Previous: "banana" + "it was ripe" -> "ripe banana"
    
    Respond with ONLY the combined food name:
    ''';

    try {
      final response = await _model.generateContent([Content.text(combinePrompt)]);
      return response.text?.trim() ?? previousFood;
    } catch (e) {
      print('Error combining food names: $e');
      return previousFood;
    }
  }

  Future<(String, int)> _extractFoodNameAndQuantity(String message) async {
    final extractPrompt = '''
    Extract the food name and quantity from this message. If no quantity is specified, assume 1.
    You must respond with ONLY a JSON object in this exact format, no other text or markdown:
    {"food": "food name", "quantity": number}

    Examples:
    Message: "track 10 big macs"
    {"food": "big mac", "quantity": 10}

    Message: "I ate 5 slices of pizza"
    {"food": "pizza slice", "quantity": 5}

    Message: "just had two sandwiches"
    {"food": "sandwich", "quantity": 2}

    Message: "track big mac"
    {"food": "big mac", "quantity": 1}

    Message: "${message}"
    ''';

    try {
      final response = await _model.generateContent([Content.text(extractPrompt)]);
      if (response.text != null) {
        String cleanedResponse = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final data = json.decode(cleanedResponse);
        return (data['food'] as String, (data['quantity'] as num).toInt());
      }
    } catch (e) {
      print('Error extracting food and quantity: $e');
    }
    return (message, 1); // Default fallback
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

      // If tracking dialog is visible and they're specifying a different food
      if (showTrackDialog && _previousFood != null && await _isSpecifyingFood(message, _previousFood!)) {
        final specifiedFood = await _extractSpecifiedFood(message);
        final combinedFood = specifiedFood ?? await _combineWithPreviousFood(message, _previousFood!);
        
        // Get nutrition data for the specified food
        final nutritionData = await _getNutritionFromText(combinedFood);
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
      }

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
          final isEatingStatement = await _isEatingStatement(message);
          
          if (isDirectCommand) {
            // Extract the food name and quantity from the command
            final (foodName, quantity) = await _extractFoodNameAndQuantity(message);
            _previousFood = foodName;

            // If it's a direct command and common food, go straight to tracking
            if (await _isCommonFood(foodName)) {
              final nutritionData = await _getNutritionFromText(foodName);
              
              // Multiply nutritional values by quantity
              nutritionData['calories'] = (nutritionData['calories'] as num) * quantity;
              nutritionData['protein'] = (nutritionData['protein'] as num) * quantity;
              nutritionData['carbs'] = (nutritionData['carbs'] as num) * quantity;
              nutritionData['fat'] = (nutritionData['fat'] as num) * quantity;
              nutritionData['serving_size'] = "${quantity}x ${nutritionData['serving_size']}";
              
              lastNutritionData = nutritionData;

              String formattedResponse =
                  'Food: ${quantity}x ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
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
              // For non-common foods, show facts but go straight to nutrition questions
              final foodInfo = await _getFoodInfo(foodName, isDirectCommand: true);
              messages.add({
                'role': 'assistant',
                'content': foodInfo,
              });
              notifyListeners();
              if (onMessageAdded != null) onMessageAdded!();
            }
          } else if (isEatingStatement) {
            // Extract the food name and quantity from the eating statement
            final (foodName, quantity) = await _extractFoodNameAndQuantity(message);
            _previousFood = foodName;

            // If it's a common food, go straight to tracking
            if (await _isCommonFood(foodName)) {
              final nutritionData = await _getNutritionFromText(foodName);
              
              // Multiply nutritional values by quantity
              nutritionData['calories'] = (nutritionData['calories'] as num) * quantity;
              nutritionData['protein'] = (nutritionData['protein'] as num) * quantity;
              nutritionData['carbs'] = (nutritionData['carbs'] as num) * quantity;
              nutritionData['fat'] = (nutritionData['fat'] as num) * quantity;
              nutritionData['serving_size'] = "${quantity}x ${nutritionData['serving_size']}";
              
              lastNutritionData = nutritionData;

              String formattedResponse =
                  'Food: ${quantity}x ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
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
              // Always ask for nutrition info for non-common foods
              final foodInfo = await _getFoodInfo(foodName, isEatingStatement: true);
              messages.add({
                'role': 'assistant',
                'content': foodInfo,
              });
              notifyListeners();
              if (onMessageAdded != null) onMessageAdded!();
              
              _isTrackingFlow = true;
            }
          } else {
            // Regular flow - show facts and ask for confirmation
            final foodInfo = await _getFoodInfo(message);
            messages.add({
              'role': 'assistant',
              'content': foodInfo,
            });
            notifyListeners();
            if (onMessageAdded != null) onMessageAdded!();
            
            _isTrackingFlow = true;
          }
        } else if (_isTrackingFlow) {
          // First check if they're specifying a different food
          if (_previousFood != null && await _isSpecifyingFood(message, _previousFood!)) {
            final specifiedFood = await _extractSpecifiedFood(message);
            final combinedFood = specifiedFood ?? await _combineWithPreviousFood(message, _previousFood!);
            
            // Get nutrition data for the specified food and show track dialog
            final nutritionData = await _getNutritionFromText(combinedFood);
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
            _isTrackingFlow = false;
            _userProvidedNutrition = null;
            return;
          }

          // If not specifying food or saying idk, continue with normal flow
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

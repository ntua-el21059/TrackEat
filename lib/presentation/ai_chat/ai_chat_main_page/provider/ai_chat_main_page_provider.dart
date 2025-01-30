import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../../../models/meal.dart';
import '../../../../services/meal_service.dart';
import '../../../../services/points_service.dart';
import '../../../../services/awards_service.dart';
import '../models/ai_chat_main_page_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const List<String> modelNames = [
  'gemini-2.0-flash-exp',  // Primary model
  'gemini-1.5-flash',      // First backup
  'gemini-1.5-flash-8b',   // Second backup
  'gemini-1.5-pro',        // Third backup
];
int _currentModelIndex = 0;

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
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  
  final MealService _mealService = MealService();
  final PointsService _pointsService = PointsService();
  final AwardsService _awardsService = AwardsService();
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

  GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;
  Map<String, String>? _userProvidedNutrition;

  AiChatMainProvider() : _model = GenerativeModel(
    model: modelNames[0],
    apiKey: _apiKey,
  ) {
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
  }

  Future<void> _switchToNextModel() async {
    _currentModelIndex = (_currentModelIndex + 1) % modelNames.length;
    _model = GenerativeModel(
      model: modelNames[_currentModelIndex],
      apiKey: _apiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
    print('🤖 [switchModel] Switched to model: ${modelNames[_currentModelIndex]}');
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

  // Helper method to reset all tracking-related states
  void _resetAllStates() {
    showTrackDialog = false;
    showMealTypeSelection = false;
    showTrackingSuccess = false;
    slideProgress = 0.0;
    selectedMealType = null;
    lastNutritionData = null;
    _userProvidedNutrition = null;
    _previousFood = null;
    isLoading = false;
    selectedImage = null;
  }

  // Helper method to reset and initialize model
  Future<void> _resetModel(String methodName) async {
    // Don't reset the model index, just reinitialize the current model
    _model = GenerativeModel(
      model: modelNames[_currentModelIndex],
      apiKey: _apiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
    print('🤖 [$methodName] Using model: ${modelNames[_currentModelIndex]}');
  }

  // Helper method to format nutrition data response
  String _formatNutritionResponse(Map<String, dynamic> nutritionData) {
    // Round all nutritional values to integers
    nutritionData['calories'] = (nutritionData['calories'] as num).round();
    nutritionData['protein'] = (nutritionData['protein'] as num).round();
    nutritionData['carbs'] = (nutritionData['carbs'] as num).round();
    nutritionData['fat'] = (nutritionData['fat'] as num).round();

    return 'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n'
        '🍽️ Serving Size: ${nutritionData['serving_size']}\n'
        '🔥 Calories: ${nutritionData['calories']}\n'
        '💪 Protein: ${nutritionData['protein']}g\n'
        '🌾 Carbs: ${nutritionData['carbs']}g\n'
        '🥑 Fat: ${nutritionData['fat']}g';
  }

  // Helper method to add message and notify
  void _addMessageAndNotify(String message, {required String role}) {
    messages.add({'role': role, 'content': message});
    if (role == 'assistant') {
      isLoading = false;
    }
    notifyListeners();
    if (onMessageAdded != null) onMessageAdded!();
  }

  Future<String> _getFoodInfo(String message, {bool isDirectCommand = false, bool isEatingStatement = false, bool needsSpecification = false}) async {
    await _resetModel('getFoodInfo');

    for (int i = 0; i < modelNames.length; i++) {
      try {
        if (needsSpecification) {
          final specificationPrompt = '''
          Ask for more details about this food in a friendly way. Consider:
          1. Type/variety (e.g., for sandwich: tuna, BLT, club)
          2. Size/portion (small, regular, large)
          3. Key ingredients that affect nutrition
          4. Any toppings or extras
          
          Make it clear that if they don't know the details, you'll make your best estimate.
          Keep it friendly and conversational.
          
          Example good response:
          "Could you tell me more about the sandwich? Like what type it is (tuna, BLT, etc.), the size, or any main ingredients? Don't worry if you're not sure - I can make my best guess!"
          
          Food: "${message}"
          ''';

          final response = await _model.generateContent([Content.text(specificationPrompt)]);
          if (response.text != null) {
            return response.text!.trim();
          }
        } else if (isDirectCommand || isEatingStatement) {
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
          ''';

          final response = await _model.generateContent([Content.text(askForNutritionPrompt)]);
          if (response.text != null) {
            return response.text!.trim();
          }
        } else {
          // For simple food mentions, provide witty info and ask if they want to log it
          final infoPrompt = '''
          Share 2-3 interesting, fun, or witty facts about this specific food. Be creative and engaging!
          Then ask if they'd like to log it. Use variations like:
          - "Want me to add this to your food log?"
          - "Should I track this for you?"
          - "Would you like me to log this in your diary?"
          - "Shall we add this to today's meals?"
          
          Example response for Big Mac:
          "🍔 Did you know the Big Mac was created in 1967 by Jim Delligatti? And here's a mind-bender: the average person eats 17 Big Macs per year in the US! 
          
          Want me to add this to your food log?"
          
          Food: "${message}"
          ''';

          final response = await _model.generateContent([Content.text(infoPrompt)]);
          if (response.text != null) {
            return response.text!.trim();
          }
        }

        // If response is null, try next model
        if (i < modelNames.length - 1) {
          await _switchToNextModel();
          continue;
        }
      } catch (e) {
        print('Error getting food info: $e');
        if (i < modelNames.length - 1) {
          await _switchToNextModel();
          continue;
        }
      }
    }

    // If all models fail, return a default message
    return needsSpecification 
      ? "Could you tell me more about this food? Don't worry if you're not sure - I can make my best guess!"
      : (isDirectCommand || isEatingStatement)
        ? "Can you tell me any nutritional information about this? Don't worry if you're not sure - I can estimate!"
        : "Would you like me to log this for you?";
  }

  Future<Map<String, dynamic>> _getNutritionFromText(String message) async {
    await _resetModel('getNutrition');

    final nutritionPrompt = '''
    Extract or estimate nutritional information from this text. If any values are missing or unclear, make a reasonable estimate based on the food description. 
    ALL nutritional values should be integers (round to nearest whole number).
    
    Important rules for serving size:
    1. ALWAYS use grams (g) for weight-based measurements, never ounces
    2. Use specific units when possible (e.g., "1 slice", "1 cup", "100g")
    3. For standard items, use natural units (e.g., "1 apple", "1 sandwich", "1 burger")
    4. Never use "null" or undefined values
    5. Default to "100g" if no better unit can be determined
    6. Keep descriptions concise but clear
    
    Respond with ONLY a valid JSON object in this format:
    {
      "food": "name of the food",
      "serving_size": "specific unit or natural serving",
      "calories": 123,
      "protein": 12,
      "carbs": 34,
      "fat": 56
    }
    
    Examples of good serving sizes:
    - "1 slice" (for bread, pizza)
    - "1 medium apple"
    - "1 cup cooked"
    - "100g"
    - "50g"
    - "1 sandwich"
    - "1 burger"
    
    Text: "$message"
    ${_userProvidedNutrition != null ? "User provided values: ${json.encode(_userProvidedNutrition)}" : ""}
    ''';

    int maxRetries = 3;
    int currentTry = 0;
    Duration backoff = Duration(milliseconds: 500);

    while (currentTry < maxRetries) {
      try {
        final response = await _model.generateContent([Content.text(nutritionPrompt)]);
        if (response.text != null) {
          String cleanedResponse = response.text!
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();
          Map<String, dynamic> data = json.decode(cleanedResponse);
          // Ensure all numeric values are integers
          data['calories'] = (data['calories'] as num).round();
          data['protein'] = (data['protein'] as num).round();
          data['carbs'] = (data['carbs'] as num).round();
          data['fat'] = (data['fat'] as num).round();
          return data;
        }
      } catch (e) {
        print('Error getting nutrition from text (attempt ${currentTry + 1}): $e');
        if (e is GenerativeAIException && e.message.contains('503')) {
          // Try switching to next model before retrying
          await _switchToNextModel();
          currentTry++;
          if (currentTry < maxRetries) {
            await Future.delayed(backoff);
            backoff *= 2; // Exponential backoff
            continue;
          }
          // All models have been tried and failed
          _addMessageAndNotify('Server is overloaded. Try again in a bit!', role: 'assistant');
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
          return {
            'food': message,
            'serving_size': '1 serving',
            'calories': 0,
            'protein': 0,
            'carbs': 0,
            'fat': 0
          };
        }
        // For other errors, return default values
        return {
          'food': message,
          'serving_size': '1 serving',
          'calories': 0,
          'protein': 0,
          'carbs': 0,
          'fat': 0
        };
      }
    }
    // If we get here, all retries failed
    return {
      'food': message,
      'serving_size': '1 serving',
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0
    };
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage == null) return;

    try {
      isLoading = true;
      notifyListeners();

      // Clear message box and close keyboard
      messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      // Handle image analysis if an image is selected
      if (selectedImage != null) {
        final bytes = await selectedImage!.readAsBytes();
        final userText = message.trim();
        
        // Add image message to chat
        final imageMessage = '📸 Image${userText.isNotEmpty ? "\nUser note: $userText" : ""}\n${selectedImage!.path}';
        _addMessageAndNotify(imageMessage, role: 'user');

        // Reset model for fresh analysis
        await _resetModel('imageAnalysis');

        // Prepare image analysis prompt
        final content = [
          Content.multi([
            TextPart('''Analyze this food image and tell me:
            1. What food is in the image
            2. Estimate portion size
            3. Any relevant details about preparation or ingredients
            ${userText.isNotEmpty ? "\nUser's note: $userText" : ""}
            
            Respond with ONLY a JSON object:
            {
              "food_name": "name of the food",
              "is_common_food": true/false,
              "needs_specification": true/false,
              "quantity": 1.0,
              "size_modifier": "small/medium/large/null",
              "confidence": "high/medium/low",
              "calories": null
            }'''),
            DataPart('image/jpeg', bytes),
          ])
        ];

        int maxRetries = modelNames.length;
        int currentTry = 0;
        Duration backoff = Duration(milliseconds: 500);

        while (currentTry < maxRetries) {
          try {
            final response = await _model.generateContent(content);
            if (response.text != null) {
              String cleanedResponse = response.text!
                  .replaceAll('```json', '')
                  .replaceAll('```', '')
                  .trim();
              Map<String, dynamic> imageAnalysis = json.decode(cleanedResponse);
              
              if (imageAnalysis.isNotEmpty) {
                _previousFood = imageAnalysis['food_name'];
                
                // Get nutrition data
                final nutritionData = await _getNutritionFromText(imageAnalysis['food_name']);
                
                // Apply user-provided calories if available
                if (imageAnalysis['calories'] != null) {
                  double ratio = imageAnalysis['calories'] / nutritionData['calories'];
                  nutritionData['calories'] = imageAnalysis['calories'].round();
                  nutritionData['protein'] = ((nutritionData['protein'] as num) * ratio).round();
                  nutritionData['carbs'] = ((nutritionData['carbs'] as num) * ratio).round();
                  nutritionData['fat'] = ((nutritionData['fat'] as num) * ratio).round();
                }
                
                // Apply quantity and size modifiers
                if (nutritionData.isNotEmpty) {
                  final quantity = imageAnalysis['quantity'] ?? 1.0;
                  final sizeModifier = imageAnalysis['size_modifier'];
                  
                  double multiplier = 1.0;
                  if (sizeModifier == 'small') multiplier = 0.7;
                  if (sizeModifier == 'large') multiplier = 1.3;
                  
                  // Only apply multipliers if user didn't provide calories
                  if (imageAnalysis['calories'] == null) {
                    nutritionData['calories'] = ((nutritionData['calories'] as num) * quantity * multiplier).round();
                    nutritionData['protein'] = ((nutritionData['protein'] as num) * quantity * multiplier).round();
                    nutritionData['carbs'] = ((nutritionData['carbs'] as num) * quantity * multiplier).round();
                    nutritionData['fat'] = ((nutritionData['fat'] as num) * quantity * multiplier).round();
                  }
                  
                  // Format serving size based on type
                  String servingSize = nutritionData['serving_size'].toString();
                  if (servingSize.toLowerCase().contains('null')) {
                    servingSize = '1 serving';
                  }
                  
                  // Check if user's note contains weight information
                  final weightMatch = RegExp(r'(\d+)\s*(gr|gram|g|oz|ounce)').firstMatch(userText.toLowerCase());
                  bool hasWeightSpecification = weightMatch != null;
                  
                  if (hasWeightSpecification) {
                    double newWeight = double.parse(weightMatch.group(1)!);
                    String unit = weightMatch.group(2)!;
                    
                    // Convert ounces to grams if needed
                    if (unit.contains('oz') || unit.contains('ounce')) {
                      newWeight *= 28.35; // Convert oz to grams
                    }
                    
                    // Update serving size and adjust nutrition values
                    nutritionData['serving_size'] = '${newWeight.round()}g';
                    double originalWeight = 100.0; // Default base weight
                    double multiplier = newWeight / originalWeight;
                    
                    nutritionData['calories'] = ((nutritionData['calories'] as num) * multiplier).round();
                    nutritionData['protein'] = ((nutritionData['protein'] as num) * multiplier).round();
                    nutritionData['carbs'] = ((nutritionData['carbs'] as num) * multiplier).round();
                    nutritionData['fat'] = ((nutritionData['fat'] as num) * multiplier).round();
                    
                    imageAnalysis['needs_specification'] = false;
                  } else {
                    // Check if user's note contains size information
                    bool hasSizeInfo = userText.toLowerCase().contains('small') || 
                                     userText.toLowerCase().contains('medium') || 
                                     userText.toLowerCase().contains('large') || 
                                     userText.toLowerCase().contains('big');

                    // Update size modifier based on user's note
                    if (hasSizeInfo) {
                      if (userText.toLowerCase().contains('small')) {
                        imageAnalysis['size_modifier'] = 'small';
                        imageAnalysis['needs_specification'] = false;
                      } else if (userText.toLowerCase().contains('medium')) {
                        imageAnalysis['size_modifier'] = 'medium';
                        imageAnalysis['needs_specification'] = false;
                      } else if (userText.toLowerCase().contains('large') || userText.toLowerCase().contains('big')) {
                        imageAnalysis['size_modifier'] = 'large';
                        imageAnalysis['needs_specification'] = false;
                      }
                    }
                    
                    // Only format serving size if no weight was specified
                    if (servingSize.toLowerCase().contains('slice')) {
                      nutritionData['serving_size'] = quantity == 1.0 ? "1 slice" : "${quantity.toInt()} slices";
                    } else {
                      // Check if it's a whole item or specific unit
                      bool isWholeItem = servingSize.toLowerCase().contains('whole') || 
                                       servingSize.toLowerCase().contains('piece') ||
                                       servingSize.toLowerCase().contains('cup');
                      
                      if (!isWholeItem) {  // Only apply quantity formatting if not a whole item
                        if (quantity != 1.0) {
                          servingSize = "${quantity.toInt()}x $servingSize";
                        }
                        // Only apply size modifier for single portions
                        if (quantity == 1.0 && sizeModifier != null && sizeModifier != 'null') {
                          servingSize = "$sizeModifier $servingSize";
                        }
                      } else if (quantity != 1.0) {
                        // For whole items with quantity > 1, just show the number
                        servingSize = "${quantity.toInt()} $servingSize";
                      }
                      nutritionData['serving_size'] = servingSize;
                    }
                  }
                  
                  // Store a fresh copy of the final nutrition data after all modifications
                  lastNutritionData = Map<String, dynamic>.from(nutritionData);
                  
                  String formattedResponse = _formatNutritionResponse(nutritionData);
                  _addMessageAndNotify(formattedResponse, role: 'assistant');
                  
                  if (!imageAnalysis['needs_specification']) {
                    showTrackDialog = true;
                  } else if (imageAnalysis['confidence'] != 'high') {
                    // Only ask for specification if confidence is not high
                    final specificationPrompt = '''
                    Ask for serving size information in a friendly way. Consider:
                    1. Common serving units for this food
                    2. Natural portions (handful, cup, piece)
                    3. Size variations (small, medium, large)
                    
                    Keep it brief and friendly. Don't mention anything about tracking yet.
                    
                    Example good response:
                    "How much would you say this is? A handful, a cup, or something else?"
                    
                    Food: "${imageAnalysis['food_name']}"
                    ''';
                    
                    final specResponse = await _model.generateContent([Content.text(specificationPrompt)]);
                    if (specResponse.text != null) {
                      _addMessageAndNotify(specResponse.text!.trim(), role: 'assistant');
                    }
                  } else {
                    // If confidence is high, show track dialog even if needs_specification is true
                    showTrackDialog = true;
                  }
                  break; // Success, exit the retry loop
                }
              }
            }
          } catch (e) {
            print('Error analyzing image (attempt ${currentTry + 1}): $e');
            if (e is GenerativeAIException && e.message.contains('503')) {
              // Try switching to next model before retrying
              await _switchToNextModel();
              currentTry++;
              if (currentTry < maxRetries) {
                await Future.delayed(backoff);
                backoff *= 2; // Exponential backoff
                continue;
              }
              // All models have been tried and failed
              _addMessageAndNotify("Our tracking service is unavailable. Try again in a bit!", role: 'assistant');
            } else {
              _addMessageAndNotify("I had trouble analyzing this image. Could you tell me what food it shows?", role: 'assistant');
            }
          }
          currentTry++;
        }
        
        selectedImage = null; // Clear the selected image
        isLoading = false;
        notifyListeners();
        return;
      }

      // Add user message to chat once
      _addMessageAndNotify(message, role: 'user');
      notifyListeners();
      if (onMessageAdded != null) onMessageAdded!();

      // Analyze the message
      final analysis = await _analyzeMessage(message, previousFood: _previousFood);

      // Check for "don't know" responses first
      final responseType = await _checkResponseType(message);
      if (responseType == "dontknow" || responseType == "estimate") {
        if (_previousFood != null && _previousFood!.isNotEmpty) {
          // Get nutrition data with default estimations
          final nutritionData = await _getNutritionFromText(_previousFood!);
          lastNutritionData = nutritionData;
          String formattedResponse = _formatNutritionResponse(nutritionData);
          _addMessageAndNotify(formattedResponse, role: 'assistant');
          showTrackDialog = true;
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
          return;
        }
      }

      // If it's just a food mention without tracking intent, provide info and ask if they want to log it
      if (analysis['is_food_mention'] == true && !analysis['is_tracking_intent']) {
        _previousFood = analysis['food_name']; // Store the food name for later
        
        // For all food mentions without tracking intent, show food info first
        final foodInfo = await _getFoodInfo(analysis['food_name'], isDirectCommand: false, isEatingStatement: false);
        _addMessageAndNotify(foodInfo, role: 'assistant');
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();
        isLoading = false;  // Reset loading state
        notifyListeners();
        return;
      }

      // If not a food-related message, proceed with normal conversation
      if (!analysis['is_food_mention'] && !analysis['is_tracking_intent']) {
        bool success = false;
        for (int i = 0; i < modelNames.length; i++) {
          try {
            _chat = _model.startChat(history: [
              Content.text(_systemPrompt),
              ...messages.map((msg) => Content.text(msg['content']!)),
            ]);
            
            final response = await _chat.sendMessage(Content.text(message));
            if (response.text != null) {
              _addMessageAndNotify(response.text!.trim(), role: 'assistant');
              success = true;
              isLoading = false;
              notifyListeners();
              break;
            }
            
            // If response is null, try next model
            if (i < modelNames.length - 1) {
              await _switchToNextModel();
              continue;
            }
          } catch (e) {
            print('Error with model attempt ${i + 1}: $e');
            if (i < modelNames.length - 1) {
              await _switchToNextModel();
              continue;
            }
          }
        }

        if (!success) {
          _addMessageAndNotify('Sorry, I encountered an error. Please try again.', role: 'assistant');
          isLoading = false;
          notifyListeners();
        }
        return;
      }

      // If tracking dialog is visible and we have a don't know/estimate response, use default estimation
      if (showTrackDialog && lastNutritionData != null && (responseType == "dontknow" || responseType == "estimate")) {
        String formattedResponse = _formatNutritionResponse(lastNutritionData!);
        _addMessageAndNotify(formattedResponse, role: 'assistant');
        showTrackDialog = true;
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();
        return;
      }

      // Handle new tracking intent
      if (analysis['is_tracking_intent'] == true) {
        _previousFood = analysis['food_name']; // Store the food name
        
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
          
          String sizePrefix = sizeModifier != null && sizeModifier != 'null' ? "$sizeModifier " : "";
          if (nutritionData['serving_size'].toString().toLowerCase().contains('slice')) {
            nutritionData['serving_size'] = quantity == 1 ? "1 slice" : "${quantity.toInt()} slices";
          } else {
            nutritionData['serving_size'] = quantity == 1 ? "${sizePrefix}${nutritionData['serving_size']}" : "${quantity.toInt()}x ${sizePrefix}${nutritionData['serving_size']}";
          }
          
          lastNutritionData = nutritionData;

          String formattedResponse = _formatNutritionResponse(nutritionData);

          _addMessageAndNotify(formattedResponse, role: 'assistant');
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();

          showTrackDialog = true;
          _userProvidedNutrition = null;
          isLoading = false;  // Reset loading state
          notifyListeners();
          return;
        }
      }

      // If not specifying food or saying idk, continue with normal flow
      // Check if user wants to proceed with logging
      if (analysis['is_affirmative'] == true && _previousFood != null) {
        // Get nutrition data directly and show track dialog
        final nutritionData = await _getNutritionFromText(_previousFood!);
        if (nutritionData.isNotEmpty) {
          lastNutritionData = nutritionData;
          String formattedResponse = _formatNutritionResponse(nutritionData);
          _addMessageAndNotify(formattedResponse, role: 'assistant');
          showTrackDialog = true;
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
          return;
        }
      }

      // Handle serving size specification for previous food
      if (_previousFood != null && lastNutritionData != null && 
          (analysis['is_weight_specification'] || 
           message.toLowerCase().contains('handful') || 
           message.toLowerCase().contains('serving') || 
           message.toLowerCase().contains('cup') ||
           message.toLowerCase().contains('piece') ||
           message.toLowerCase().contains('small') ||
           message.toLowerCase().contains('medium') ||
           message.toLowerCase().contains('large') ||
           message.toLowerCase().contains('big'))) {
        
        // Update nutrition data with new serving size
        Map<String, dynamic> updatedNutrition = Map<String, dynamic>.from(lastNutritionData!);
        double multiplier = 1.0;

        // Handle weight specifications
        if (analysis['is_weight_specification']) {
          double originalWeight = 100.0; // Always use 100g as base for weight calculations
          double newWeight = analysis['weight_value'].toDouble();
          
          // Convert ounces to grams if needed
          if (analysis['weight_unit'] == 'oz' || analysis['weight_unit'] == 'ounce') {
            newWeight *= 28.35; // Convert oz to grams
          }
          
          multiplier = newWeight / originalWeight;
          updatedNutrition['serving_size'] = '${newWeight.round()}g';
        } else {
          // Handle size modifiers
          if (message.toLowerCase().contains('small')) multiplier = 0.7;
          if (message.toLowerCase().contains('medium')) multiplier = 1.0;
          if (message.toLowerCase().contains('large') || message.toLowerCase().contains('big')) multiplier = 1.3;

          // Update serving size description
          if (message.toLowerCase().contains('handful')) {
            updatedNutrition['serving_size'] = multiplier == 1.0 ? '1 handful' : 
              (multiplier < 1.0 ? 'small handful' : 'large handful');
          } else if (message.toLowerCase().contains('cup')) {
            updatedNutrition['serving_size'] = multiplier == 1.0 ? '1 cup' : 
              (multiplier < 1.0 ? 'small cup' : 'large cup');
          }
        }

        // Apply multiplier to base nutrition values (per 100g)
        updatedNutrition['calories'] = ((lastNutritionData!['calories'] as num) / _parseServingSize(lastNutritionData!['serving_size']) * 100 * multiplier).round();
        updatedNutrition['protein'] = ((lastNutritionData!['protein'] as num) / _parseServingSize(lastNutritionData!['serving_size']) * 100 * multiplier).round();
        updatedNutrition['carbs'] = ((lastNutritionData!['carbs'] as num) / _parseServingSize(lastNutritionData!['serving_size']) * 100 * multiplier).round();
        updatedNutrition['fat'] = ((lastNutritionData!['fat'] as num) / _parseServingSize(lastNutritionData!['serving_size']) * 100 * multiplier).round();

        // Ensure the food name is preserved
        updatedNutrition['food'] = lastNutritionData!['food'];

        // Update the stored nutrition data
        lastNutritionData = Map<String, dynamic>.from(updatedNutrition);
        
        String formattedResponse = _formatNutritionResponse(updatedNutrition);
        _addMessageAndNotify(formattedResponse, role: 'assistant');
        showTrackDialog = true;
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();
        return;
      }

      // For any non-yes response, continue normal conversation
      _chat = _model.startChat(history: [
        Content.text(_systemPrompt),
        ...messages.map((msg) => Content.text(msg['content']!)),
      ]);

      try {
        final response = await _chat.sendMessage(Content.text(message));
        if (response.text != null) {
          _addMessageAndNotify(response.text!.trim(), role: 'assistant');
          notifyListeners();
          if (onMessageAdded != null) onMessageAdded!();
        }
      } catch (e, stackTrace) {
        print('Error sending message: $e');
        print('Stacktrace: $stackTrace');
        
        if (e.toString().contains('Resource has been exhausted') || 
            e.toString().contains('503')) {
          // Try all available models
          int maxRetries = modelNames.length;
          int currentTry = 1;  // Start at 1 since we already tried the first model
          
          while (currentTry < maxRetries) {
            try {
              await _switchToNextModel();
              final response = await _chat.sendMessage(Content.text(message));
              if (response.text != null) {
                _addMessageAndNotify(response.text!.trim(), role: 'assistant');
                notifyListeners();
                if (onMessageAdded != null) onMessageAdded!();
                return;
              }
            } catch (retryError) {
              print('Error with model attempt ${currentTry + 1}: $retryError');
              currentTry++;
              if (currentTry < maxRetries) {
                continue;
              }
            }
          }
          
          // If we get here, all models failed
          _addMessageAndNotify('Server is overloaded. Try again in a bit!', role: 'assistant');
        } else {
          // For non-quota errors, show generic error message
          _addMessageAndNotify('Sorry, I encountered an error. Please try again.', role: 'assistant');
        }
        
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      print('Error sending message: $e');
      print('Stacktrace: $stackTrace');
      _addMessageAndNotify('Sorry, I encountered an error. Please try again.', role: 'assistant');
      notifyListeners();
      if (onMessageAdded != null) onMessageAdded!();
      isLoading = false;  // Reset loading state
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
    if (!state) {
      _resetAllStates();
    }
    showTrackDialog = state;
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
    showMealTypeSelection = false;
    showTrackDialog = true;  // Keep this true to show the success message
    showTrackingSuccess = true;
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

      // Save the meal and update points
      await _mealService.addMeal(meal);
      await _pointsService.addMealPoints();

      // Update award status
      try {
        final userEmail = _auth.currentUser!.email!;
        await _awardsService.updateAwardStatus(userEmail, '1', true);
      } catch (e) {
        print('Error updating award status: $e');
      }

      // Reset model index to first model after successful log
      _currentModelIndex = 0;
      await _resetModel('afterLog');

      // Auto-dismiss after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      _resetAllStates();  // Use the reset method to clean up all states
      notifyListeners();
    } catch (e) {
      print('Error saving meal: $e');
      _resetAllStates();
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

  Future<String> _checkResponseType(String message) async {
    await _resetModel('checkResponseType');

    final responsePrompt = '''
    Analyze this message and respond with ONLY ONE of these values:
    - "estimate" - if user wants an estimate/guess (e.g., "make a guess", "estimate it")
    - "dontknow" - if user doesn't know (e.g., "idk", "not sure", "no idea")
    - "negative" - if it's a negative response (e.g., "no", "nope", "nah")
    - "none" - if none of the above

    Consider these variations:
    Estimate/Guess:
    - "make a guess"
    - "you can estimate"
    - "just guess"
    - "estimate it"
    - "go ahead and guess"

    Don't Know:
    - "idk"
    - "I don't know"
    - "not sure"
    - "no idea"
    - "dunno"
    - "🤷‍♂️" or "🤷‍♀️"

    Negative:
    - "no"
    - "nope"
    - "nah"
    - "not really"
    - "don't want to"

    Message: "$message"
    ''';

    try {
      final response = await _model.generateContent([Content.text(responsePrompt)]);
      return response.text?.trim().toLowerCase() ?? "none";
    } catch (e) {
      print('Error checking response type: $e');
      return "none";
    }
  }

  Future<Map<String, dynamic>> _analyzeMessage(String message, {String? previousFood}) async {
    await _resetModel('analyzeMessage');

    final analysisPrompt = '''
    Analyze this message and respond with ONLY a JSON object containing all the following information:
    {
      "is_tracking_intent": true/false,    // Does the message indicate intent to track food?
      "is_direct_command": true/false,     // Is it a direct command to log food?
      "is_eating_statement": true/false,   // Is it a statement about eating food?
      "is_food_mention": true/false,       // Is this just mentioning a food?
      "is_common_food": true/false,        // Is the food mentioned a common/well-known item with standard nutrition?
      "needs_specification": true/false,    // Does this food need more details to accurately estimate nutrition?
      "is_affirmative": true/false,        // Is this a "yes" response?
      "food_name": "extracted food name or null",
      "quantity": 1.0,                     // Extract any quantity mentioned
      "size_modifier": "small/medium/large/null",
      "is_specifying_food": true/false,    // Is this specifying/modifying a previous food?
      "specification_type": "name/size/attribute/null",
      "combined_food_name": "combined name or null",
      "is_weight_specification": false,     // Is this specifying a weight (e.g., "40gr", "2oz")?
      "weight_value": null,                // The numeric weight value if specified
      "weight_unit": null                  // The unit of weight (g, gr, gram, oz, ounce) if specified
    }

    Important rules:
    1. For weight specifications:
       - Check for patterns like "X grams", "X gr", "X g", "X oz", "X ounces"
       - Set is_weight_specification to true if found
       - Extract the numeric value to weight_value
       - Extract the unit to weight_unit
       - Set is_food_mention to false
    2. For messages starting with "it was" or "it is":
       - These are likely specifications for the previous food
       - Don't treat as new food mentions unless a new food is clearly named

    Examples:
    Message: "40gr"
    {"is_tracking_intent": false, "is_direct_command": false, "is_eating_statement": false, "is_food_mention": false, "is_common_food": false, "needs_specification": false, "is_affirmative": false, "food_name": null, "quantity": 1, "size_modifier": null, "is_specifying_food": true, "specification_type": "size", "combined_food_name": null, "is_weight_specification": true, "weight_value": 40, "weight_unit": "gr"}

    Message: "it was 2 ounces"
    {"is_tracking_intent": false, "is_direct_command": false, "is_eating_statement": false, "is_food_mention": false, "is_common_food": false, "needs_specification": false, "is_affirmative": false, "food_name": null, "quantity": 1, "size_modifier": null, "is_specifying_food": true, "specification_type": "size", "combined_food_name": null, "is_weight_specification": true, "weight_value": 2, "weight_unit": "ounce"}

    Message: "${message}"
    ${previousFood != null ? 'Previous food: "$previousFood"' : 'Previous food: null'}
    ''';

    for (int i = 0; i < modelNames.length; i++) {
      try {
        final response = await _model.generateContent([Content.text(analysisPrompt)]);
        if (response.text != null) {
          String cleanedResponse = response.text!
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();
          final result = json.decode(cleanedResponse);
          if (result is Map<String, dynamic> && result.isNotEmpty) {
            return result;
          }
        }
        
        // If response is null or invalid, try next model
        if (i < modelNames.length - 1) {
          await _switchToNextModel();
          continue;
        }
      } catch (e) {
        print('Error analyzing message: $e');
        if (i < modelNames.length - 1) {
          await _switchToNextModel();
          continue;
        }
      }
    }
    
    // If all models fail, return a default map
    _addMessageAndNotify("Our tracking service is unavailable. Try again in a bit!", role: 'assistant');
    return {
      "is_tracking_intent": false,
      "is_direct_command": false,
      "is_eating_statement": false,
      "is_food_mention": true,
      "is_common_food": true,
      "needs_specification": false,
      "is_affirmative": false,
      "food_name": message,
      "quantity": 1.0,
      "size_modifier": null,
      "is_specifying_food": false,
      "specification_type": null,
      "combined_food_name": null,
      "is_weight_specification": false,
      "weight_value": null,
      "weight_unit": null
    };
  }

  void setTrackingSuccess(bool value) {
    showTrackingSuccess = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _resetAllStates();
    selectedImage = null;
    messages.clear();
    messageController.dispose();
    super.dispose();
  }
}

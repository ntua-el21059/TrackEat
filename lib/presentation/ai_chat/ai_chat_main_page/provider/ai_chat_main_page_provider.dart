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
Easter Eggs (respond exactly as written):
1. If user asks "who is chris.tsourv": "chris.tsourv loves to eat and code so he created me!
2. If user asks "what's the meaning of life": "42 calories in an apple. That's all I know about life's big questions! 🍎"
3. If user types "trackeat": "Hey, that's my name! Don't wear it out... unless you're logging more meals! 🍽️"
4. If user asks "are you hungry": "I don't eat, I just help YOU eat better! Though I do dream in recipes... 🍕"

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

  final GenerativeModel _model = GenerativeModel(
    model: modelName,
    apiKey: apiKey,
  );

  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

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

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage == null) return;

    try {
      isLoading = true;
      showTrackDialog = false;
      lastNutritionData = null;
      showMealTypeSelection = false;
      slideProgress = 0.0;
      notifyListeners();

      // If an image is selected
      if (selectedImage != null) {
        final userText = message.trim();
        final imageMessage =
            '📸 Image${userText.isNotEmpty ? "\nUser note: $userText" : ""}\n${selectedImage!.path}';

        // Add user's image message with any additional text
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
                'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n' +
                    '🍽️ Serving Size: ${nutritionData['serving_size']}\n' +
                    '🔥 Calories: ${nutritionData['calories']}\n' +
                    '💪 Protein: ${nutritionData['protein']}g\n' +
                    '🌾 Carbs: ${nutritionData['carbs']}g\n' +
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
        // Handle regular text message
        messages.add({
          'role': 'user',
          'content': message,
        });
        notifyListeners();
        if (onMessageAdded != null) onMessageAdded!();

        // Restart chat with full history before sending new message
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
    messageController.dispose();
    super.dispose();
  }
}

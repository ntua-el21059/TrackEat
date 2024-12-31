import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../../../models/meal.dart';
import '../../../../services/meal_service.dart';
import '../models/ai_chat_main_page_model.dart';

const String apiKey = 'AIzaSyDe5fyQXDIfgZ1paU5Ax5HNj6gNyWA0MAA';
const String modelName = 'gemini-2.0-flash-exp';

const String _systemPrompt = '''
You are TrackEat AI, a witty and helpful food logging assistant. Your primary purpose is to help users track their meals and nutrition.

When users ask questions:
1. If it's food-related: Provide helpful, accurate information about nutrition, meal logging, and healthy eating habits.
2. If it's NOT food-related: Respond with a clever, food-themed redirection. For example:
   - For tech questions: "While I could byte into that topic, I'm better at helping you track what you bite into!"
   - For weather: "Instead of the weather forecast, how about we forecast your next delicious meal?"
   - For general chat: "That's food for thought, but let's focus on the actual food you'd like to track!"

Always maintain a friendly, witty tone while guiding users back to food-related discussions.
''';

class AiChatMainProvider extends ChangeNotifier {
  final MealService _mealService = MealService();
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
    _chat = _model.startChat(history: [
      Content.text(_systemPrompt)
    ]);
  }

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
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
        // Add user's image message
        messages.add({
          'role': 'user',
          'content': '📸 Image\n${selectedImage!.path}',
        });
        notifyListeners();

        // Prepare image analysis prompt
        const imagePrompt = """You are a nutrition analysis assistant. Look at this food image and respond ONLY with a valid JSON object in exactly this format, with no additional text or markdown:
{
  "food": "name of the food",
  "serving_size": "detected serving size",
  "calories": 123,
  "protein": 12,
  "carbs": 34,
  "fat": 56
}
Important: Respond with ONLY the JSON object, no other text.""";

        // Send image to Gemini
        final content = Content.multi([
          TextPart(imagePrompt),
          DataPart('image/jpeg', await selectedImage!.readAsBytes()),
        ]);

        final response = await _model.generateContent([content]);
        final responseText = response.text;
        print('Raw LLM Response: $responseText');

        if (responseText != null) {
          try {
            // Clean and parse JSON response
            String cleanedResponse = responseText
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();
            print('Cleaned Response: $cleanedResponse');
            
            Map<String, dynamic> nutritionData = jsonDecode(cleanedResponse);
            print('Parsed Nutrition Data: $nutritionData');
            lastNutritionData = nutritionData;
            
            String formattedResponse = 'Food: ${nutritionData['food'].toString().split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ')}\n' +
                '🍽️ Serving Size: ${nutritionData['serving_size']}\n' +
                '🔥 Calories: ${nutritionData['calories']}\n' +
                '💪 Protein: ${nutritionData['protein']}g\n' +
                '🌾 Carbs: ${nutritionData['carbs']}g\n' +
                '🥑 Fat: ${nutritionData['fat']}g';
            
            print('Formatted Response: $formattedResponse');

            // Add the formatted response to messages
            messages.add({
              'role': 'assistant',
              'content': formattedResponse,
            });
            
            // Show track dialog after response
            showTrackDialog = true;
            
            print('Added message to chat: ${messages.last}');
          } catch (e) {
            print('Error parsing nutrition data: $e');
            messages.add({
              'role': 'assistant',
              'content': 'Sorry, I had trouble analyzing the nutritional information. Please try again.',
            });
          }
        }
      } else {
        // Handle regular text message
        messages.add({
          'role': 'user',
          'content': message,
        });

        final response = await _chat.sendMessage(Content.text(message));
        if (response.text != null) {
          messages.add({
            'role': 'assistant',
            'content': response.text!.trim(),
          });
        }
      }

      notifyListeners();
      Future.delayed(const Duration(milliseconds: 100), () {
        onMessageAdded?.call();
      });

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
        userId: _auth.currentUser!.uid,
        name: lastNutritionData!['food'],
        mealType: mealType.toLowerCase(),
        calories: lastNutritionData!['calories'],
        servingSize: double.parse(lastNutritionData!['serving_size'].replaceAll(RegExp(r'[^0-9.]'), '')),
        macros: {
          'protein': lastNutritionData!['protein'].toDouble(),
          'fats': lastNutritionData!['fat'].toDouble(),
          'carbs': lastNutritionData!['carbs'].toDouble(),
        },
        date: DateTime.now(),
      );

      // Save to Firebase
      await _mealService.addMeal(meal);

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

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
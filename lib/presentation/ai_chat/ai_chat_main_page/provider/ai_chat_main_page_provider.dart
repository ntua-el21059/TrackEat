import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
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
  TextEditingController messageController = TextEditingController();
  AiChatMainModel aiChatMainModelObj = AiChatMainModel();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;
  bool showTrackDialog = false;
  Map<String, dynamic>? lastNutritionData;
  
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
      // TODO: Implement tracking logic
      showTrackDialog = false;
      notifyListeners();
    }
  }

  void setTrackDialogState(bool state) {
    showTrackDialog = state;
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
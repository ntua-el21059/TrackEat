import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../../../core/app_export.dart';
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
      selectedImage = image;
      notifyListeners();
    }
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage == null) return;

    try {
      isLoading = true;
      notifyListeners();

      String userMessage = message;
      Map<String, dynamic>? nutritionData;

      // If an image is selected, analyze it first
      if (selectedImage != null) {
        nutritionData = await _analyzeImage(selectedImage!.path);
        
        // Prepare the user message with only the image path
        messages.add({
          'role': 'user',
          'content': '📸 Image\n${selectedImage!.path}',
        });
      }

      // Add user text message if not empty
      if (message.trim().isNotEmpty) {
        messages.add({
          'role': 'user',
          'content': message,
        });
      }

      notifyListeners();
      
      // Delay slightly to ensure UI updates before scrolling
      Future.delayed(const Duration(milliseconds: 100), () {
        onMessageAdded?.call();
      });

      // Prepare the content for sending to Gemini
      final content = selectedImage != null
          ? Content.multi([
              TextPart(message),
              DataPart('image/jpeg', await selectedImage!.readAsBytes()),
            ])
          : Content.text(message);

      // Send message to Gemini
      final response = await _chat.sendMessage(content);
      final responseText = response.text;

      if (responseText != null) {
        // Add AI response to the list
        messages.add({
          'role': 'assistant',
          'content': responseText.trim(),
        });
        
        // If nutrition data was extracted, add it as a separate message
        if (nutritionData != null) {
          messages.add({
            'role': 'assistant',
            'content': '🍽️ Nutrition Information:\n'
                      'Food: ${nutritionData['food']}\n'
                      'Serving Size: ${nutritionData['serving_size']}\n'
                      'Calories: ${nutritionData['calories']}\n'
                      'Protein: ${nutritionData['protein']}g\n'
                      'Carbs: ${nutritionData['carbs']}g\n'
                      'Fat: ${nutritionData['fat']}g',
          });
        }

        notifyListeners();
        
        // Delay slightly to ensure UI updates before scrolling
        Future.delayed(const Duration(milliseconds: 100), () {
          onMessageAdded?.call();
        });
      }

      messageController.clear();
      removeImage(); // Clear the selected image after sending
    } catch (e) {
      print('Error sending message: $e');
      messages.add({
        'role': 'assistant',
        'content': 'Sorry, I encountered an error. Please try again.',
      });
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 100), () {
        onMessageAdded?.call();
      });
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> _analyzeImage(String imagePath) async {
    try {
      // Initialize the Generative Model
      final generativeModel = GenerativeModel(
        model: modelName,
        apiKey: apiKey,
      );

      // Load the image as bytes
      Uint8List imageBytes = await XFile(imagePath).readAsBytes();

      // Create the prompt
      const prompt = """
      You are a nutrition analysis assistant. Given the image, identify the food and respond ONLY with a structured answer containing the estimated nutritional information for the serving in the picture. 

      The answer should follow this structure:

      {
        "food": "<food_name>",
        "serving_size": "<serving_size>",
        "calories": <integer>,
        "protein": <integer>,
        "carbs": <integer>,
        "fat": <integer>
      }

      If unsure, make your best guess.
      """;

      // Prepare the content for the request
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      // Send the request to the model
      final response = await generativeModel.generateContent(content);

      // Extract and clean the response text
      String? responseText = response.text;
      if (responseText != null) {
        responseText = responseText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        print('Cleaned Response: $responseText');

        // Parse the cleaned JSON
        final nutritionData = jsonDecode(responseText);
        print('Nutrition Data: $nutritionData');
        return nutritionData;
      }
    } catch (e) {
      print('Error analyzing image: $e');
    }
    return null;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
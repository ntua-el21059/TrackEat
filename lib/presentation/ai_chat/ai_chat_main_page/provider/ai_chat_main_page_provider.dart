import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
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
      if (selectedImage != null) {
        userMessage = '📸 Image attached: ${selectedImage!.path.split('/').last}\n$message';
      }

      // Add user message to the list
      messages.add({
        'role': 'user',
        'content': userMessage,
      });
      notifyListeners();
      
      // Delay slightly to ensure UI updates before scrolling
      Future.delayed(const Duration(milliseconds: 100), () {
        onMessageAdded?.call();
      });

      // Send message to Gemini
      final response = await _chat.sendMessage(Content.text(userMessage));
      final responseText = response.text;

      if (responseText != null) {
        // Add AI response to the list
        messages.add({
          'role': 'assistant',
          'content': responseText.trim(),
        });
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

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
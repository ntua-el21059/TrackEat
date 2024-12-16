import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String apiKey = 'AIzaSyDe5fyQXDIfgZ1paU5Ax5HNj6gNyWA0MAA'; // Replace with your Gemini API key
const String modelName = 'gemini-2.0-flash-exp'; // Use the appropriate Gemini model

Future<void> analyzeImage(String imagePath) async {
  try {
    // Initialize the Generative Model
    final generativeModel = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
    );

    // Load the image as bytes
    ByteData imageData = await rootBundle.load(imagePath);
    Uint8List imageBytes = imageData.buffer.asUint8List();

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
        DataPart('image/jpeg', imageBytes), // Ensure the MIME type matches the image format
      ])
    ];

    // Send the request to the model
    final response = await generativeModel.generateContent(content);

    // Extract and clean the response text
    String? responseText = response.text;
    if (responseText != null) {
      responseText = responseText
          .replaceAll('```json', '') // Remove the ```json markers
          .replaceAll('```', '')    // Remove any ``` markers
          .trim();                  // Remove surrounding whitespace
      print('Cleaned Response: $responseText');

      // Parse the cleaned JSON
      final nutritionData = jsonDecode(responseText);
      print('Nutrition Data: $nutritionData');
    } else {
      print('No response received from the API.');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
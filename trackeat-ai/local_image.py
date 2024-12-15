import PIL.Image
import os
import google.generativeai as genai

# Configure the Gemini API
genai.configure(api_key="AIzaSyDe5fyQXDIfgZ1paU5Ax5HNj6gNyWA0MAA")

# Load the image
image_path = "trackeat-ai/testing-photos/Chicken-Alfredo-V3.jpg"  # Path to your image
sample_file = PIL.Image.open(image_path)

# Choose a Gemini model
model = genai.GenerativeModel(model_name="gemini-2.0-flash-exp")

# Adjust the prompt to request the response in JSON format
prompt = """
You are a nutrition analysis assistant. Given the image, identify the food and respond ONLY with a JSON object containing the estimated nutritional information for the serving in the picture. Do not include any text besides the JSON object.

The JSON should follow this structure:

{
  "calories": <integer>,
  "protein": <integer>,
  "carbs": <integer>,
  "fat": <integer>
}

If unsure, make your best guess.
"""

# Send the prompt and the image to the Gemini model
response = model.generate_content([prompt, sample_file])

# Print the response
print(response.text)
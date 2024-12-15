import google.generativeai as genai

genai.configure(api_key="AIzaSyDe5fyQXDIfgZ1paU5Ax5HNj6gNyWA0MAA")

import httpx
import base64

# Retrieve an image
image_path = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Palace_of_Westminster_from_the_dome_on_Methodist_Central_Hall.jpg/2560px-Palace_of_Westminster_from_the_dome_on_Methodist_Central_Hall.jpg"
image = httpx.get(image_path)

# Choose a Gemini model
model = genai.GenerativeModel(model_name="gemini-1.5-flash")

# Create a prompt
prompt = "Caption this image."
response = model.generate_content(
    [
        {
            "mime_type": "image/jpeg",
            "data": base64.b64encode(image.content).decode("utf-8"),
        },
        prompt,
    ]
)

print(">" + response.text)

# For low res mode, we expect a 512px x 512px image. 
# For high res mode, the short side of the image should be less than 768px and the long side should be less than 2,000px.
# All images with detail: low cost 85 tokens each. 
# detail: high images are first scaled to fit within a 2048 x 2048 square, maintaining their aspect ratio.

import base64
from openai import OpenAI

client = OpenAI()

# Function to encode the image
def encode_image(image_path):
  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode('utf-8')

# Path to your image
image_path = "path_to_your_image.jpg"

# Getting the base64 string
base64_image = encode_image(image_path)

response = client.chat.completions.create(
  model="gpt-4o-mini",
  messages=[
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "What is in this image?",
        },
        {
          "type": "image_url",
          "image_url": {
            "url":  f"data:image/jpeg;base64,{base64_image}",
            "detail": "auto" # can be set to "low", "high", or "auto"
          },
        },
      ],
    }
  ],
)

print(response.choices[0])
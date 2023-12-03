from flask import Flask, render_template, request, jsonify
import numpy as np
from PIL import Image
import base64
import os
from io import BytesIO
import tensorflow
from tensorflow.keras.models import load_model

app = Flask(__name__)

model = load_model("C:/Users/Shrishti Vaish/Documents/Projects/Python/Flask/tf_digit_classifier.h5")  # Replace with your model path

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    # Get the image file from the request
    image_file = request.files['file']

    # Process the image
    img = Image.open(image_file).convert('L')  # Convert to grayscale
    img = img.resize((28, 28))  # Resize to MNIST input size
    img_array = np.array(img).reshape(1, 28, 28, 1)  # Normalize

    # Make prediction
    prediction = model.predict(img_array)
    predicted_digit = np.argmax(prediction)

    # Convert the PIL Image to base64-encoded bytes
    img_bytes = BytesIO()
    img.save(img_bytes, format='PNG')
    img_base64 = base64.b64encode(img_bytes.getvalue()).decode('utf-8')

    # Create a response with the base64-encoded image and prediction
    response = {
        'prediction': int(predicted_digit),
        'image': {
            'format': 'png',
            'data': img_base64
        }
    }

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)

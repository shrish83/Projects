import streamlit as st
import numpy as np
from PIL import Image
import tensorflow as tf
from tensorflow.keras import models

# Load the trained model
model = models.load_model("C:/Users/Shrishti Vaish/Documents/Projects/Python/Streamlit_NN_MNIST/tf_digit_classifier.h5")  # Replace with your model path

st.title("Handwritten Digit Recognition")

uploaded_file = st.file_uploader("Choose an image...", type=["png", "jpg"])

if uploaded_file is not None:
    image = Image.open(uploaded_file)
    st.image(image, caption='Uploaded Image.', use_column_width=True)
    st.write("")
    st.write("Classifying...")

    # Preprocess the image
    img = np.array(image.resize((28, 28)))
    img = img[:, :, 0]  # Convert to grayscale
    img = img.reshape(1, 28 * 28).astype('float32') / 255.0  # Reshape and normalize

    # Perform prediction using the model
    prediction = model.predict(img)
    predicted_class = np.argmax(prediction)

    st.write(f"Prediction: {predicted_class}")

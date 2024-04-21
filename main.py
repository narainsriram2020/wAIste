import base64
from flask import Flask, request, jsonify
from inference_sdk import InferenceHTTPClient

app = Flask(__name__)

EXISTING_MODEL_CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key="PmV06ZjRdZCfnXoJbJj5"
)

NEW_MODEL_CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key="PmV06ZjRdZCfnXoJbJj5"
)

@app.route('/upload', methods=['POST'])
def upload_image():
    try:
        if 'image' not in request.json:
            return jsonify({'error': 'No image provided'}), 400

        base64_image = request.json['image']

        # Decode base64 image
        image_data = base64.b64decode(base64_image)

        # Save the image to a temporary location
        image_path = 'temp_image.jpg'
        with open(image_path, 'wb') as f:
            f.write(image_data)

        # Perform inference with new model first
        new_model_result = NEW_MODEL_CLIENT.infer(image_path, model_id="garbage_detection-wvzwv/9")
        new_model_predictions = new_model_result['predictions']

        if new_model_predictions:  # If garbage is detected by new model
            confidence_level = new_model_predictions[0]['confidence']
            if confidence_level >= 0.55:  # Check if confidence level is greater than or equal to 55%
                return jsonify({'predictions': new_model_predictions}), 200

        # If confidence level is less than 55% or no garbage detected, use existing model
        existing_model_result = EXISTING_MODEL_CLIENT.infer(image_path, model_id="garbage-classification-3/2")
        existing_model_predictions = existing_model_result['predictions']
        return jsonify({'predictions': existing_model_predictions}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
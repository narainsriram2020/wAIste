# wAIste

**wAIste** is an innovative waste management application powered by artificial intelligence (AI). Our app revolutionizes waste disposal processes by employing state-of-the-art machine learning algorithms to analyze images of waste items captured by users. By harnessing the power of AI, wAIste provides personalized recommendations for proper waste disposal methods, including recycling, composting, or landfill. What sets wAIste apart is its utilization of two distinct AI models: one for general waste categorization and another for advanced garbage detection. With its intuitive interface and real-time insights, wAIste empowers users to make informed decisions about waste management, contributing to a cleaner and more sustainable environment.

## Key Features:

- **AI-Powered Analysis:** Utilizes two different machine learning models to accurately identify and categorize waste. The first model, for general waste categorization, classifies waste items into categories such as biodegradable, cardboard, glass, metal, paper, and plastic, providing users with detailed insights into the composition of their waste. The second model, for advanced garbage detection, identifies the presence of garbage in images and provides bounding boxes and confidence scores for detected garbage items. By combining the capabilities of these two models, wAIste offers comprehensive waste management solutions tailored to individual user needs.

- **Real-time Recommendations:** Provides real-time recommendations for proper waste disposal methods based on AI analysis. Users receive instant feedback on whether an item can be recycled, composted, or disposed of in a landfill, enabling them to make environmentally conscious decisions on the spot.

- **User-Friendly Interface:** Features an intuitive and user-friendly interface designed for seamless navigation and ease of use. Users can simply capture an image of their waste item within the app and receive immediate recommendations, making waste management quick and effortless.

[![wAIste Demo](https://img.youtube.com/vi/ZyRgfsvGNfk/0.jpg)](https://youtu.be/ZyRgfsvGNfk)

Check out the [wAIste Demo](https://youtu.be/ZyRgfsvGNfk) to see the app in action!

## Flask Server:

For the backend infrastructure, wAIste employs a Flask server to handle image processing and AI model inference. The Flask server, hosted at [wAIste Flask Server](https://github.com/aluthra23/wAIste_flask_server), acts as the backend API for the mobile application. It utilizes the Roboflow platform's inference SDK to integrate with machine learning models for waste categorization and garbage detection. The Flask server enables seamless communication between the frontend mobile app and the AI models, ensuring efficient waste management recommendations for users.

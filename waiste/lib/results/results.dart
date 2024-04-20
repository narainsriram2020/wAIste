import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsPage extends StatefulWidget {
  final String imageBase64;

  ResultsPage({required this.imageBase64});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String apiKey =
      'sk-proj-ejzicAZGoL3ldgFa5sCFT3BlbkFJ1RjujWM1xwvBDlOQSNLI'; // Replace with your API key
  String prompt =
      'is this recycling, compost or trash'; // Replace with your prompt
  String generatedResponse = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Call the function to fetch the response from ChatGPT API
    getChatGPTResponse();
  }

  Future<void> getChatGPTResponse() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'max_tokens': 1000, // Adjust as needed
          'temperature': 0.4, // Adjust as needed
          //'images': ['data:image/jpeg;base64,${widget.imageBase64}'],
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          generatedResponse = data['choices'][0]['text'];
          isLoading = false;
        });
      } else {
        setState(() {
          generatedResponse = 'Error: Failed to get response from ChatGPT API';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        generatedResponse = 'Error: $e';
        isLoading = false;
      });
      debugPrint(generatedResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(generatedResponse),
              ),
      ),
    );
  }
}

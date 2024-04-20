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
  String apiUrl = 'http://127.0.0.1:5000/';

  Future<Map<String, dynamic>> getPredictions(String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl + 'upload'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'image': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON response
        final jsonResponse = jsonDecode(response.body);
        final List<Map<String, dynamic>> predictions = List.from(jsonResponse['predictions']);
        final firstPrediction = predictions.isNotEmpty ? predictions.first : null;
        return firstPrediction ?? {};
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to get predictions: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an exception
      throw Exception('Failed to get predictions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Center(
        child: FutureBuilder(
          future: getPredictions(widget.imageBase64),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Display the first prediction received from the Flask server
              final prediction = snapshot.data ?? {};
              return ListTile(
                title: Text('Class: ${prediction['class'] ?? 'N/A'}'),
                subtitle: Text('Confidence: ${prediction['confidence'] ?? 'N/A'}'),
              );
            }
          },
        ),
      ),
    );
  }
}

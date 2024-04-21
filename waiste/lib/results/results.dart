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
        final List<Map<String, dynamic>> predictions =
            List.from(jsonResponse['predictions']);
        final firstPrediction =
            predictions.isNotEmpty ? predictions.first : null;
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

  String getCategory(String predictedClass) {
    switch (predictedClass) {
      case 'BIODEGRADABLE':
        return 'Compost';
      case 'CARDBOARD':
        return 'Compost and Recycling';
      case 'GLASS':
        return 'Recycling';
      case 'METAL':
        return 'Recycling';
      case 'PAPER':
        return 'Recycling and Compost';
      case 'PLASTIC':
        return 'Recycling';
      default:
        return 'Trash';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPredictions(widget.imageBase64),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Color appBarColor = Colors.green;
        Color screenColor = Colors.green;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Results',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: appBarColor,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Results',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: appBarColor,
            ),
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          // Display the first prediction received from the Flask server
          final prediction = snapshot.data ?? {};
          if ((prediction['class'] ?? '') == 'METAL') {
            appBarColor = Color.fromARGB(255, 47, 51, 48);
            screenColor = Color.fromARGB(255, 47, 51, 48);
          } else if ((prediction['class'] ?? '') == 'PLASTIC') {
            appBarColor = Color.fromARGB(255, 64, 104, 177);
            screenColor = Color.fromARGB(255, 64, 104, 177);
          } else if ((prediction['class'] ?? '') == 'CARDBOARD' ||
              (prediction['class'] ?? '') == 'PAPER') {
            appBarColor = Color.fromARGB(255, 102, 88, 43);
            screenColor = Color.fromARGB(255, 102, 88, 43);
          } else if ((prediction['class'] ?? '') == 'GLASS') {
            appBarColor = Color.fromARGB(255, 178, 157, 232);
            screenColor = Color.fromARGB(255, 178, 157, 232);
          }
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: Colors.white), // Setting the icon color to white
              title: Text('Results', style: TextStyle(color: Colors.white)),
              backgroundColor: appBarColor,
            ),
            backgroundColor: screenColor,
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Predicted Category:',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      getCategory(prediction['class'] ?? ''),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Confidence:',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${(double.parse((prediction['confidence'] ?? 0.0).toStringAsFixed(4)) * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

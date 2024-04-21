import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsPage extends StatelessWidget {
  final String imageBase64;

  ResultsPage({required this.imageBase64});

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
    switch (predictedClass.toUpperCase()) {
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
      case 'GARBAGE':
        return 'Trash';
      default:
        return 'Unknown';
    }
  }

  String getDescription(String predictedClass) {
    switch (predictedClass.toUpperCase()) {
      case 'BIODEGRADABLE':
        return 'Biodegradable items are those that break down naturally in the environment. These items can be composted and turned into nutrient-rich soil.';
      case 'CARDBOARD':
        return 'Cardboard items are recyclable and can also be composted if they are not contaminated with food or liquids.';
      case 'GLASS':
        return 'Glass items are recyclable. Once recycled, glass can be melted down and used to make new products without losing quality.';
      case 'METAL':
        return 'Metal items such as aluminum and steel cans are highly recyclable. Recycling metal helps save energy and conserve natural resources.';
      case 'PAPER':
        return 'Paper items are recyclable and can also be composted if they are not coated with plastic or other non-biodegradable materials.';
      case 'PLASTIC':
        return 'Plastic items are recyclable, but many types of plastic are not accepted by recycling facilities. Check your local recycling guidelines for more information.';
      case 'GARBAGE':
        return 'Garbage items are non-recyclable and non-biodegradable waste that should be disposed of properly in a landfill.';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPredictions(imageBase64),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Color appBarColor = Colors.green;
        Color screenColor = Colors.green;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
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
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
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
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          // Display the prediction information
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
          } else if ((prediction['class'] ?? '').toString().toLowerCase() ==
              'garbage') {
            appBarColor = Color.fromARGB(255, 24, 25, 22);
            screenColor = Color.fromARGB(255, 24, 26, 23);
          }

          String confidence = ((prediction['confidence'] ?? 0.0) * 100)
              .toStringAsFixed(0); // Convert to percentage without decimals

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                'Results',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: appBarColor,
            ),
            backgroundColor: screenColor,
            body: Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
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
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        String category = getCategory(prediction['class'] ?? '');
                        String description =
                            getDescription(prediction['class'] ?? '');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(category),
                              content: Text(description),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        getCategory(prediction['class'] ?? ''),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '$confidence%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        String category = getCategory(prediction['class'] ?? '');
                        String description =
                            getDescription(prediction['class'] ?? '');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(category),
                              content: Text(description),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: appBarColor,
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'More Info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

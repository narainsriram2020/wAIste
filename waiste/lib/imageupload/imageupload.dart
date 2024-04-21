import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:waiste/results/results.dart'; // Assuming this is your ResultsPage

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({Key? key});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _selectedImage;

  Future<void> pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      final imageFile = File(pickedImage.path);
      setState(() {
        _selectedImage = imageFile;
      });
    } catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future<void> continueToResults() async {
    if (_selectedImage == null) {
      // Show error message if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'No Image Selected!.',
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 20, // Font size
              ),
              textAlign: TextAlign.center,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red, // Error message background color
          behavior: SnackBarBehavior.floating, // Center the message
        ),
      );
      return;
    }

    // Encode the image as base64
    String base64Image = base64Encode(await _selectedImage!.readAsBytes());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(imageBase64: base64Image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white), // Setting the icon color to white
        title: const Text(
          'Upload Image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green, // Setting app bar color to green
      ),
      body: Container(
        color: Colors.green, // Setting background color to green
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _selectedImage == null
                  ? const Text(
                      'No image selected.',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white), // Text color
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(_selectedImage!),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white, // Button text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Button border radius
                  ),
                ),
                child: const Text(
                  'Select Image',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: continueToResults,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white, // Button text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Button border radius
                  ),
                ),
                child: const Text(
                  'Continue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

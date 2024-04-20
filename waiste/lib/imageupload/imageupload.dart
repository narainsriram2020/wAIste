import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:waiste/results/results.dart'; // Assuming this is your ResultsPage

class ImageUploadPage extends StatefulWidget {
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
    if (_selectedImage == null) return;

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
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectedImage == null
                ? Text('No image selected.')
                : Image.file(_selectedImage!),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: continueToResults,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

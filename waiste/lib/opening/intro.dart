import 'package:flutter/material.dart';
import 'package:waiste/imageupload/imageupload.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageUploadPage()),
            );
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}

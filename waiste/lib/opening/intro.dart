import 'package:flutter/material.dart';
import 'package:waiste/imageupload/imageupload.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageUploadPage()),
            );
          },
          child: Text('Start'),
        ),
      ),
    );
  }
}

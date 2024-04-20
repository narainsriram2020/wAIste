import 'package:flutter/material.dart';
import 'package:waiste/imageupload/imageupload.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/waistelogo.png',
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImageUploadPage()),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Start!",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 8), // Add some space between text and icon
                  Icon(Icons.arrow_forward, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

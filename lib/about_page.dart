import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.photo, size: 64),
            SizedBox(height: 16),
            Text(
              'Gallery App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Made by Nikhil Bendale'),
            SizedBox(height: 8),
            Text('Flutter • Android'),
          ],
        ),
      ),
    );
  }
}

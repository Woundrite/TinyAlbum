import 'package:flutter/material.dart';
import 'gallery_page.dart';

void main() {
  runApp(const Gallery());
}

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
      home: const GalleryPage(),
    );
  }
}

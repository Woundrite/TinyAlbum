import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageViewer extends StatelessWidget {
  final AssetEntity image;

  const ImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: image.file,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Center(
                child: InteractiveViewer(child: Image.file(snapshot.data!)),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

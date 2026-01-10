import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'text_controller.dart';
import 'text_canvas.dart';
import 'text_rasterizer.dart';
import '../edit_top_bar.dart';

class TextEditor extends StatelessWidget {
  final TextController controller;
  final Uint8List baseImage;
  final ValueChanged<Uint8List> onDone;
  final VoidCallback onBack; // 🔥 IMPORTANT

  const TextEditor({
    super.key,
    required this.controller,
    required this.baseImage,
    required this.onDone,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BASE IMAGE
        Center(child: Image.memory(baseImage)),

        // TEXT OVERLAY
        TextCanvas(controller: controller),

        // TOP BAR
        EditTopBar(
          onBack: () {
            controller.clear();
            onBack(); // ✅ NO Navigator.pop
          },
          onSave: () async {
            final bytes = await rasterizeText(
              baseImage: baseImage,
              layers: controller.layers,
            );
            onDone(bytes);
          },
        ),

        // CONTROLS
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // COLOR PICKER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: controller.colors.map((c) {
                    return GestureDetector(
                      onTap: () => controller.currentColor = c,
                      child: CircleAvatar(
                        backgroundColor: c,
                        radius: 14,
                      ),
                    );
                  }).toList(),
                ),

                // FONT SIZE
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    return Slider(
                      min: 12,
                      max: 64,
                      value: controller.fontSize,
                      onChanged: (v) => controller.fontSize = v,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



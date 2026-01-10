import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'doodle_controller.dart';
import 'doodle_canvas.dart';
import 'doodle_rasterizer.dart';
import '../edit_top_bar.dart';

class DoodleEditor extends StatelessWidget {
  final DoodleController controller;
  final Uint8List baseImage;
  final ValueChanged<Uint8List> onDone;
  final VoidCallback onBack; // 🔥 IMPORTANT

  const DoodleEditor({
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
        // BASE IMAGE + CANVAS
        Center(child: Image.memory(baseImage)),
        DoodleCanvas(controller: controller),

        // TOP BAR
        EditTopBar(
          onBack: () {
            controller.clear();
            onBack(); // ✅ NO Navigator.pop
          },
          onSave: () async {
            final bytes = await rasterizeDoodle(
              baseImage: baseImage,
              strokes: controller.strokes,
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
                // COLORS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: controller.colors.map((c) {
                    return GestureDetector(
                      onTap: () {
                        controller.color = c;
                        controller.notifyListeners();
                      },
                      child: CircleAvatar(
                        backgroundColor: c,
                        radius: 14,
                      ),
                    );
                  }).toList(),
                ),

                // STROKE WIDTH
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    return Slider(
                      min: 2,
                      max: 24,
                      value: controller.strokeWidth,
                      onChanged: (v) {
                        controller.strokeWidth = v;
                        controller.notifyListeners();
                      },
                    );
                  },
                ),

                // OPACITY
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    return Slider(
                      min: 0.1,
                      max: 1.0,
                      value: controller.opacity,
                      onChanged: (v) {
                        controller.opacity = v;
                        controller.notifyListeners();
                      },
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

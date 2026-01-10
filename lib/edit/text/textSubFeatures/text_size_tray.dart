import 'package:flutter/material.dart';
import '../text_controller.dart';

class TextSizeTray extends StatelessWidget {
  final TextController controller;

  const TextSizeTray({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller, // 🟢 LISTENS to changes
      builder: (_, __) {
        return Slider(
          min: 12,
          max: 96,
          value: controller.active.fontSize,
          onChanged: (v) {
            controller.update((layer) => layer.fontSize = v);
          },
        );
      },
    );
  }
}
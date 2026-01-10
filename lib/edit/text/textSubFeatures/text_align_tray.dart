import 'package:flutter/material.dart';
import '../text_controller.dart';

class TextAlignTray extends StatelessWidget {
  final TextController controller;

  const TextAlignTray({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.format_align_left),
          onPressed: () =>
              controller.update((l) => l.align = TextAlign.left),
        ),
        IconButton(
          icon: const Icon(Icons.format_align_center),
          onPressed: () =>
              controller.update((l) => l.align = TextAlign.center),
        ),
        IconButton(
          icon: const Icon(Icons.format_align_right),
          onPressed: () =>
              controller.update((l) => l.align = TextAlign.right),
        ),
      ],
    );
  }
}


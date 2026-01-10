import 'package:flutter/material.dart';
import '../text_controller.dart';

class TextColorTray extends StatelessWidget {
  final TextController controller;

  const TextColorTray({super.key, required this.controller});

  static const List<Color> _colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _colors.length,
            itemBuilder: (_, i) {
              final color = _colors[i];
              final isActive = controller.active.color == color;

              return GestureDetector(
                onTap: () {
                  controller.update((layer) => layer.color = color);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isActive
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


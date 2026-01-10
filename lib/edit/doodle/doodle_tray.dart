import 'package:flutter/material.dart';
import 'doodle_controller.dart';

class DoodleTray extends StatelessWidget {
  final DoodleController controller;

  const DoodleTray({super.key, required this.controller});

  static const colors = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // COLORS
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: colors.map((c) {
              return GestureDetector(
                onTap: () {
                  controller
                    ..color = c
                    ..isEraser = false
                    ..notifyListeners();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // SIZE
        Slider(
          min: 2,
          max: 24,
          value: controller.strokeWidth,
          onChanged: (v) {
            controller.strokeWidth = v;
            controller.notifyListeners();
          },
        ),

        // OPACITY
        Slider(
          min: 0.1,
          max: 1,
          value: controller.opacity,
          onChanged: (v) {
            controller.opacity = v;
            controller.notifyListeners();
          },
        ),

        // ACTIONS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: controller.undo,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: controller.redo,
            ),
            IconButton(
              icon: const Icon(Icons.cleaning_services),
              onPressed: controller.clear,
            ),
            IconButton(
              icon: const Icon(Icons.auto_fix_off),
              onPressed: () {
                controller.isEraser = true;
                controller.notifyListeners();
              },
            ),
          ],
        ),
      ],
    );
  }
}

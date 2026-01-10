import 'package:flutter/material.dart';
import 'doodle_controller.dart';

class DoodleCanvas extends StatelessWidget {
  final DoodleController controller;

  const DoodleCanvas({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => controller.start(d.localPosition),
      onPanUpdate: (d) => controller.update(d.localPosition),
      child: CustomPaint(
        painter: _DoodlePainter(controller),
        size: Size.infinite,
      ),
    );
  }
}

class _DoodlePainter extends CustomPainter {
  final DoodleController controller;

  _DoodlePainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in controller.strokes) {
      canvas.drawPath(stroke.path, stroke.paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

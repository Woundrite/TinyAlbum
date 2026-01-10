import 'package:flutter/material.dart';

class DoodleStroke {
  final Path path;
  final Paint paint;

  DoodleStroke(this.path, this.paint);
}

class DoodleController extends ChangeNotifier {
  final List<DoodleStroke> strokes = [];
  final List<DoodleStroke> _redo = [];

  // 🎨 AVAILABLE COLORS (🟢 ADDED)
  final List<Color> colors = const [
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

  Color color = Colors.white;
  double strokeWidth = 6;
  double opacity = 1.0;
  bool isEraser = false;

  void start(Offset pos) {
    final paint = Paint()
      ..color = isEraser
          ? Colors.transparent
          : color.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode =
      isEraser ? BlendMode.clear : BlendMode.srcOver;

    final path = Path()..moveTo(pos.dx, pos.dy);

    strokes.add(DoodleStroke(path, paint));
    _redo.clear();
    notifyListeners();
  }

  void update(Offset pos) {
    strokes.last.path.lineTo(pos.dx, pos.dy);
    notifyListeners();
  }

  void undo() {
    if (strokes.isEmpty) return;
    _redo.add(strokes.removeLast());
    notifyListeners();
  }

  void redo() {
    if (_redo.isEmpty) return;
    strokes.add(_redo.removeLast());
    notifyListeners();
  }

  void clear() {
    strokes.clear();
    _redo.clear();
    notifyListeners();
  }
}


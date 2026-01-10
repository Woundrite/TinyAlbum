import 'package:flutter/material.dart';
import 'text_layer.dart';

class TextController extends ChangeNotifier {
  final List<TextLayer> layers = [];
  int activeIndex = -1;

  // 🎨 AVAILABLE COLORS
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
    Colors.grey,
  ];

  /// Initialize text editing
  void initialize(Size canvasSize) {
    if (layers.isNotEmpty) return;

    layers.add(
      TextLayer(
        position: const Offset(0.5, 0.5), // 🟢 normalized center
      ),
    );
    activeIndex = 0;
    notifyListeners();
  }


  // 🔹 ACTIVE LAYER
  TextLayer get active => layers[activeIndex];

  // 🔹 COLOR
  Color get currentColor => active.color;
  set currentColor(Color c) {
    active.color = c;
    notifyListeners();
  }

  // 🔹 FONT SIZE
  double get fontSize => active.fontSize;
  set fontSize(double v) {
    active.fontSize = v;
    notifyListeners();
  }

  // 🔹 UPDATE HELPER
  void update(void Function(TextLayer layer) fn) {
    fn(active);
    notifyListeners();
  }

  // 🔹 RESET
  void clear() {
    layers.clear();
    activeIndex = -1;
    notifyListeners();
  }
}


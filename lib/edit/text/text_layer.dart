import 'package:flutter/material.dart';

class TextLayer {
  Offset position;
  String text;
  double fontSize;
  Color color;
  TextAlign align;
  double rotation;

  TextLayer({
    required this.position,
    this.text = "Text",
    this.fontSize = 32,
    this.color = Colors.white,
    this.align = TextAlign.center,
    this.rotation = 0,
  });
}

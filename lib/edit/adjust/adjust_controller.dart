import 'package:flutter/material.dart';

class AdjustController extends ChangeNotifier {
  double value = 0.0;

  void set(double v) {
    value = v;
    notifyListeners();
  }

  void reset() {
    value = 0.0;
    notifyListeners();
  }
}

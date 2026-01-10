import 'dart:ui';
import 'adjust_feature.dart';

ColorFilter buildAdjustFilter(AdjustType type, double v) {
  switch (type) {
    case AdjustType.exposure:
    case AdjustType.brightness:
      final b = v * 255;
      return ColorFilter.matrix([
        1, 0, 0, 0, b,
        0, 1, 0, 0, b,
        0, 0, 1, 0, b,
        0, 0, 0, 1, 0,
      ]);

    case AdjustType.contrast:
      final c = v + 1;
      return ColorFilter.matrix([
        c, 0, 0, 0, 128 * (1 - c),
        0, c, 0, 0, 128 * (1 - c),
        0, 0, c, 0, 128 * (1 - c),
        0, 0, 0, 1, 0,
      ]);

    case AdjustType.saturation:
    case AdjustType.vibrance:
      final s = v + 1;
      return ColorFilter.matrix([
        0.213 + 0.787 * s, 0.715 - 0.715 * s, 0.072 - 0.072 * s, 0, 0,
        0.213 - 0.213 * s, 0.715 + 0.285 * s, 0.072 - 0.072 * s, 0, 0,
        0.213 - 0.213 * s, 0.715 - 0.715 * s, 0.072 + 0.928 * s, 0, 0,
        0, 0, 0, 1, 0,
      ]);

    case AdjustType.temperature:
      return ColorFilter.matrix([
        1, 0, 0, 0, v * 30,
        0, 1, 0, 0, 0,
        0, 0, 1, 0, -v * 30,
        0, 0, 0, 1, 0,
      ]);

    default:
      return const ColorFilter.mode(Color(0x00000000), BlendMode.dst);
  }
}

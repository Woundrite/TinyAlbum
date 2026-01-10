import 'package:flutter/material.dart';

enum AdjustType {
  exposure,
  brightness,
  contrast,
  saturation,
  vibrance,
  temperature,
  sharpness,
  shadows,
  highlights,
  brilliance,
}

class AdjustFeature {
  final AdjustType type;
  final String label;
  final IconData icon;
  final double min;
  final double max;

  const AdjustFeature({
    required this.type,
    required this.label,
    required this.icon,
    required this.min,
    required this.max,
  });
}

const List<AdjustFeature> adjustFeatures = [
  AdjustFeature(type: AdjustType.exposure, label: "Exposure", icon: Icons.exposure, min: -1, max: 1),
  AdjustFeature(type: AdjustType.brightness, label: "Brightness", icon: Icons.brightness_6, min: -1, max: 1),
  AdjustFeature(type: AdjustType.contrast, label: "Contrast", icon: Icons.contrast, min: -1, max: 1),
  AdjustFeature(type: AdjustType.saturation, label: "Saturation", icon: Icons.water_drop, min: -1, max: 1),
  AdjustFeature(type: AdjustType.vibrance, label: "Vibrance", icon: Icons.auto_awesome, min: -1, max: 1),
  AdjustFeature(type: AdjustType.temperature, label: "Warmth", icon: Icons.thermostat, min: -1, max: 1),
  AdjustFeature(type: AdjustType.sharpness, label: "Sharpness", icon: Icons.blur_on, min: 0, max: 1),
  AdjustFeature(type: AdjustType.shadows, label: "Shadows", icon: Icons.dark_mode, min: -1, max: 1),
  AdjustFeature(type: AdjustType.highlights, label: "Highlights", icon: Icons.light_mode, min: -1, max: 1),
  AdjustFeature(type: AdjustType.brilliance, label: "Brilliance", icon: Icons.auto_fix_high, min: -1, max: 1),
];

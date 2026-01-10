import 'package:flutter/material.dart';
import '../edit_feature_item.dart';

EditFeatureItem flipVerticalEditFeature({
  required VoidCallback onFlip,
}) {
  return EditFeatureItem(
    icon: Icons.flip_camera_android,
    label: "Flip V",
    onTap: onFlip,
  );
}

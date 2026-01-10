import 'package:flutter/material.dart';
import '../edit_feature_item.dart';

EditFeatureItem rotateEditFeature({
  required VoidCallback onRotate,
}) {
  return EditFeatureItem(
    icon: Icons.rotate_right,
    label: "Rotate",
    onTap: onRotate,
  );
}

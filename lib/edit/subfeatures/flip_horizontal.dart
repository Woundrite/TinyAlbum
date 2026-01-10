import 'package:flutter/material.dart';
import '../edit_feature_item.dart';

EditFeatureItem flipHorizontalEditFeature({
  required VoidCallback onFlip,
}) {
  return EditFeatureItem(
    icon: Icons.flip,
    label: "Flip H",
    onTap: onFlip,
  );
}

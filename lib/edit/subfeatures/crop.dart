import 'package:flutter/material.dart';
import '../edit_feature_item.dart';

EditFeatureItem cropEditFeature({
  required VoidCallback onActivate,
}) {
  return EditFeatureItem(
    icon: Icons.crop,
    label: "Crop",
    onTap: onActivate,
  );
}

import 'package:flutter/material.dart';

class EditFeatureItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  EditFeatureItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}


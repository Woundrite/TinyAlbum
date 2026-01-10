import 'package:flutter/material.dart';

/// Data-only model for a More menu item
class MoreItem {
  final String title;
  final VoidCallback onTap;

  MoreItem({
    required this.title,
    required this.onTap,
  });
}

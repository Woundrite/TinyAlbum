import 'package:flutter/material.dart';

enum AppTheme { system, light, dark, indigo, emerald }

final appThemes = {
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
  ),
  AppTheme.dark: ThemeData(brightness: Brightness.dark, useMaterial3: true),
  AppTheme.indigo: ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
  ),
  AppTheme.emerald: ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
  ),
};

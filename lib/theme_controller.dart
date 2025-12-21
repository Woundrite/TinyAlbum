import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ThemeController extends ChangeNotifier {
  static const _key = 'theme';
  AppTheme _theme = AppTheme.system;

  AppTheme get theme => _theme;

  ThemeMode get mode =>
      _theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get data => appThemes[_theme] ?? appThemes[AppTheme.light]!;

  ThemeController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null) {
      _theme = AppTheme.values[index];
      notifyListeners();
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    _theme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_key, theme.index);
  }
}

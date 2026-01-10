import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_controller.dart';
import 'home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiny Album',
      theme: theme.data,
      themeMode: theme.mode,
      home: const Home(),
    );
  }
}

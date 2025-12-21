import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_controller.dart';
import 'theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AppTheme>(
              value: controller.theme,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select theme',
              ),
              items: AppTheme.values
                  .map(
                    (theme) =>
                        DropdownMenuItem(value: theme, child: Text(theme.name)),
                  )
                  .toList(),
              onChanged: (theme) => controller.setTheme(theme!),
            ),
          ],
        ),
      ),
    );
  }
}

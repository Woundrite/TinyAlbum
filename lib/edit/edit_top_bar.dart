import 'package:flutter/material.dart';

/// Global top bar shown while inside sub-tools
/// (Text, Doodle, etc.)
class EditTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;

  const EditTopBar({
    super.key,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 100,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BACK
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),

            // SAVE
            TextButton(
              onPressed: onSave,
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class UndoRedoBar extends StatelessWidget {
  final bool canUndo;
  final bool canRedo;
  final VoidCallback onUndo;
  final VoidCallback onRedo;

  const UndoRedoBar({
    super.key,
    required this.canUndo,
    required this.canRedo,
    required this.onUndo,
    required this.onRedo,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 56,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              icon: Icons.undo,
              enabled: canUndo,
              onTap: onUndo,
            ),
            _button(
              icon: Icons.redo,
              enabled: canRedo,
              onTap: onRedo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: enabled ? Colors.white : Colors.white38,
      ),
      onPressed: enabled ? onTap : null,
    );
  }
}

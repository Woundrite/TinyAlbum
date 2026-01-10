import 'package:flutter/material.dart';

enum SaveAction {
  replace,
  copy,
}

Future<SaveAction?> showSaveSheet(BuildContext context) {
  return showModalBottomSheet<SaveAction>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Save file",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'If you choose "Replace original", the edits will be applied '
                  'to the original, but you can still revert the edits.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            _action(
              context,
              label: "Replace original",
              action: SaveAction.replace,
            ),

            _divider(),

            _action(
              context,
              label: "Save copy",
              action: SaveAction.copy,
            ),

            _divider(),

            _action(
              context,
              label: "Cancel",
              action: null,
            ),
          ],
        ),
      );
    },
  );
}

Widget _divider() {
  return const Divider(height: 1, thickness: 0.6);
}

Widget _action(
    BuildContext context, {
      required String label,
      SaveAction? action,
    }) {
  return TextButton(
    onPressed: () => Navigator.pop(context, action),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: action == null ? Colors.red : Colors.blue,
        ),
      ),
    ),
  );
}

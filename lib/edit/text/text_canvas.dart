import 'package:flutter/material.dart';
import 'text_controller.dart';

class TextCanvas extends StatelessWidget {
  final TextController controller;

  const TextCanvas({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = constraints.biggest;

        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Stack(
              children: controller.layers.map((layer) {
                // 🔹 Convert normalized → screen space
                final screenPos = Offset(
                  layer.position.dx * size.width,
                  layer.position.dy * size.height,
                );

                return Positioned(
                  left: screenPos.dx,
                  top: screenPos.dy,
                  child: GestureDetector(
                    onPanUpdate: (d) {
                      // 🔹 Convert screen delta → normalized delta
                      layer.position += Offset(
                        d.delta.dx / size.width,
                        d.delta.dy / size.height,
                      );
                      controller.notifyListeners();
                    },
                    child: Transform.rotate(
                      angle: layer.rotation,
                      child: GestureDetector(
                        onTap: () async {
                          final newText =
                          await _showTextInputDialog(context, layer.text);
                          if (newText != null && newText.isNotEmpty) {
                            controller.update((l) => l.text = newText);
                          }
                        },
                        child: Text(
                          layer.text,
                          style: TextStyle(
                            fontSize: layer.fontSize,
                            color: layer.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}


Future<String?> _showTextInputDialog(
    BuildContext context,
    String initialText,
    ) {
  final controller = TextEditingController(text: initialText);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Enter text",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      );
    },
  );
}

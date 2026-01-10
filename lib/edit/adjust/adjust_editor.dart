import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'adjust_feature.dart';
import 'adjust_controller.dart';
import 'adjust_matrices.dart';
import 'adjust_rasterizer.dart';
import '../edit_top_bar.dart';

class AdjustEditor extends StatelessWidget {
  final Uint8List baseImage;
  final AdjustFeature feature;
  final AdjustController controller;
  final ValueChanged<Uint8List> onDone;
  final VoidCallback onBack; // 🔥 IMPORTANT

  const AdjustEditor({
    super.key,
    required this.baseImage,
    required this.feature,
    required this.controller,
    required this.onDone,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // IMAGE PREVIEW
        Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return ColorFiltered(
                colorFilter:
                buildAdjustFilter(feature.type, controller.value),
                child: Image.memory(baseImage),
              );
            },
          ),
        ),

        // TOP BAR
        EditTopBar(
          onBack: onBack, // ✅ NO Navigator.pop
          onSave: () async {
            final bytes = await rasterizeAdjust(
              baseImage,
              feature.type,
              controller.value,
            );
            onDone(bytes);
          },
        ),

        // SLIDER
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      feature.label,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Slider(
                      min: feature.min,
                      max: feature.max,
                      value: controller.value,
                      onChanged: controller.set,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}


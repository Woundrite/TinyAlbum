import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';

class CropEditor extends StatefulWidget {
  final Uint8List imageBytes;
  final ValueChanged<Uint8List> onCropped;

  const CropEditor({
    super.key,
    required this.imageBytes,
    required this.onCropped,
  });

  @override
  State<CropEditor> createState() => _CropEditorState();
}

class _CropEditorState extends State<CropEditor> {
  final CropController _controller = CropController();
  double? _aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Crop(
            controller: _controller,
            image: widget.imageBytes,
            aspectRatio: _aspectRatio,
            onCropped: widget.onCropped,
            withCircleUi: false,
            baseColor: Colors.black,
            maskColor: Colors.black.withOpacity(0.65),
            cornerDotBuilder: (size, _) {
              return Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ratio("Free", null),
              _ratio("1:1", 1),
              _ratio("4:3", 4 / 3),
              _ratio("16:9", 16 / 9),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ratio(String label, double? ratio) {
    final active = _aspectRatio == ratio;
    return TextButton(
      onPressed: () => setState(() => _aspectRatio = ratio),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.blue : Colors.white,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


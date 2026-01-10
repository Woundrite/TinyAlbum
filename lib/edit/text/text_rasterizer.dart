import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'text_layer.dart';

Future<Uint8List> rasterizeText({
  required Uint8List baseImage,
  required List<TextLayer> layers,
}) async {
  final codec = await ui.instantiateImageCodec(baseImage);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  canvas.drawImage(image, Offset.zero, Paint());

  for (final layer in layers) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: layer.text,
        style: TextStyle(
          fontSize: layer.fontSize,
          color: layer.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      textAlign: layer.align,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // 🔹 Convert normalized → image pixel space
    final imagePos = Offset(
      layer.position.dx * image.width,
      layer.position.dy * image.height,
    );

    canvas.save();
    canvas.translate(imagePos.dx, imagePos.dy);
    canvas.rotate(layer.rotation);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  final picture = recorder.endRecording();
  final finalImage =
  await picture.toImage(image.width, image.height);

  final byteData =
  await finalImage.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}


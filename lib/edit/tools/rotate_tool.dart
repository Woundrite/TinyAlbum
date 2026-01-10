import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Rotates image bytes by 90 degrees clockwise
Uint8List rotate90(Uint8List bytes) {
  final original = img.decodeImage(bytes);
  if (original == null) return bytes;

  final rotated = img.copyRotate(
    original,
    angle: 90,
  );

  return Uint8List.fromList(
    img.encodeJpg(rotated),
  );
}

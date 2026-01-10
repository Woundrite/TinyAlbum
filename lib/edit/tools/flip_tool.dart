import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Flip image horizontally (mirror left ↔ right)
Uint8List flipHorizontal(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) return bytes;

  final flipped = img.flipHorizontal(image);
  return Uint8List.fromList(img.encodeJpg(flipped));
}

/// Flip image vertically (mirror top ↔ bottom)
Uint8List flipVertical(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) return bytes;

  final flipped = img.flipVertical(image);
  return Uint8List.fromList(img.encodeJpg(flipped));
}

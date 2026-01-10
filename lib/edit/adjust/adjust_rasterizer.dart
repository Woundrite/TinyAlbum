import 'dart:typed_data';
import 'dart:ui';
import 'adjust_feature.dart';
import 'adjust_matrices.dart';

Future<Uint8List> rasterizeAdjust(
    Uint8List baseImage,
    AdjustType type,
    double value,
    ) async {
  final codec = await instantiateImageCodec(baseImage);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  final paint = Paint()
    ..colorFilter = buildAdjustFilter(type, value);

  canvas.drawImage(image, Offset.zero, paint);

  final outImage =
  await recorder.endRecording().toImage(image.width, image.height);

  final byteData =
  await outImage.toByteData(format: ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}

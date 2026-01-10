import 'dart:typed_data';
import 'dart:ui'; // 🟢 IMPORTANT: no prefix
import 'doodle_controller.dart';

Future<Uint8List> rasterizeDoodle({
  required Uint8List baseImage,
  required List<DoodleStroke> strokes,
}) async {
  final codec = await instantiateImageCodec(baseImage);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  canvas.drawImage(image, Offset.zero, Paint());

  for (final stroke in strokes) {
    canvas.drawPath(stroke.path, stroke.paint);
  }

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(
    image.width,
    image.height,
  );

  final byteData = await finalImage.toByteData(
    format: ImageByteFormat.png,
  );

  return byteData!.buffer.asUint8List();
}


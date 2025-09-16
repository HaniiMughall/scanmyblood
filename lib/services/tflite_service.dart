import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('model.tflite');
  }

  List<double> predict(File imageFile) {
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
    image = img.copyResize(image, width: 224, height: 224);

    var input = imageToFloat32List(image);
    var output = List.filled(1 * 8, 0).reshape([1, 8]);

    _interpreter.run(input, output);
    return output[0].cast<double>();
  }

  Float32List imageToFloat32List(img.Image image) {
    var convertedBytes = Float32List(1 * 224 * 224 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int index = 0;
    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        var pixel = image.getPixel(x, y);
        buffer[index++] = ((pixel >> 16) & 0xFF) / 255.0;
        buffer[index++] = ((pixel >> 8) & 0xFF) / 255.0;
        buffer[index++] = (pixel & 0xFF) / 255.0;
      }
    }
    return convertedBytes;
  }
}

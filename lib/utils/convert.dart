import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart';

class DecodeParam {
  static const LOSSLESS = 0;
  static const LOSSY = 1;
  
  int format;
  num quality;

  final List<File> file;
  final SendPort sendPort;

DecodeParam(
    this.file,
    this.sendPort,
    {
      this.format = LOSSY,
      this.quality = 100
    }
  );
}


void decodeIsolate(DecodeParam param) {
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  Animation? animation = decodeAnimation(param.file[0].readAsBytesSync());
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  // var thumbnail = copyResize(image, width: 120);
  param.sendPort.send(animation);
}


void encodeIsolate(DecodeParam param) {

  WebPEncoder webpEncoder = new WebPEncoder(
    format: param.format,
    quality: param.quality,
  );

  for(int i = 0; i < param.file.length; i++) {
    Image? currImage = decodeImage(param.file[i].readAsBytesSync());
    webpEncoder.addFrame(currImage!);
  }



}





Future<void> main(List<String> args) async {
  var receivePort = ReceivePort();

  await Isolate.spawn(
    decodeIsolate,
    DecodeParam(
      [File('test.webp')],
      receivePort.sendPort
    ),
  );

  // Get the processed image from the isolate.
  Animation animation = await receivePort.first as Animation;
  List<Image> imageFrames = animation.frames;
  for(int i = 0; i < imageFrames.length; i++) {
    await File('png/thumbnail$i.png').writeAsBytes(encodePng(imageFrames[i]));
  }
}


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CustomCamera {
  static Future<dynamic> openCamera({bool getBase64 = true}) async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (getBase64 == true) {
      List<int> base64Byte = image.readAsBytesSync();

      final encodedStr = base64Encode(base64Byte);
      Uint8List bytes = base64.decode(encodedStr);

      final result = await ImageGallerySaver.saveImage(bytes);
      String path = result['filePath'];
      path = path.substring(7);
      return path;
    }

    return image;
  }

  static Future<dynamic> openGallery({bool getBase64 = true}) async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (getBase64 == true) {
      List<int> base64Byte = image.readAsBytesSync();
      String base64Encoded = base64Encode(base64Byte);

      final encodedStr = base64Encode(base64Byte);
      Uint8List bytes = base64.decode(encodedStr);

      final result = await ImageGallerySaver.saveImage(bytes);
      String path = result['filePath'];
      path = path.substring(7);
      return path;
    }

    return image;
  }
}

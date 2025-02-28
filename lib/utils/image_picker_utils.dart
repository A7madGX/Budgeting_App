import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  ImagePickerUtils._();

  static Future<List<File>> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(limit: 3);
    if (pickedFiles.isEmpty) return [];
    return pickedFiles.map((file) => File(file.path)).toList();
  }
}

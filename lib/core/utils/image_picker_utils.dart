import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<List<File>> pickImage() async {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  final List<XFile> selectedImages = await imagePicker.pickMultiImage(
    imageQuality: 25,
  );
  if (selectedImages.isNotEmpty) {
    imageFileList.addAll(selectedImages);
  }
  List<File> files = imageFileList.map((file) => File(file.path)).toList();
  return files;
}

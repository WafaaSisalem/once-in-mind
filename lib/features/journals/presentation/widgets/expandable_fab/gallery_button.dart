import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';

class GalleryButton extends StatefulWidget {
  final Function(List<File> urls) onPressed;

  const GalleryButton({super.key, required this.onPressed});

  @override
  State<GalleryButton> createState() => _GalleryButtonState();
}

class _GalleryButtonState extends State<GalleryButton> {
  List<File> selectedFile = [];

  @override
  Widget build(BuildContext context) {
    return CustomChildFab(
      heroTag: 'btn1',
      child: selectedFile.isEmpty
          ? AppAssets.svgGallery
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.file(selectedFile.first, fit: BoxFit.cover),
            ),
      onPressed: () async {
        selectedFile = await pickImage();
        setState(() {});
        if (selectedFile.isNotEmpty) {
          widget.onPressed(selectedFile);
        }
      },
    );
  }

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
}

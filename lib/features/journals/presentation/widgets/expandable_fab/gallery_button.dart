import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/image_picker_utils.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';
import 'package:onceinmind/features/journals/presentation/widgets/pick_image_widget.dart';

class GalleryButton extends StatefulWidget {
  final Function(List<File> selectedFiles) onPressed;

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
        if (selectedFile.isEmpty) {
          selectedFile = await pickImage();
        } else {
          selectedFile = await showDialog(
            context: context,
            builder: (ctx) {
              return PickImageWidget(selectedFiles: selectedFile);
            },
          );
        }
        widget.onPressed(selectedFile);

        setState(() {});
      },
    );
  }
}

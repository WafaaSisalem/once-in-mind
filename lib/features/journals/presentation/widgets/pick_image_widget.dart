import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/image_picker_utils.dart';

class PickImageWidget extends StatefulWidget {
  final List<File> selectedFiles;
  const PickImageWidget({super.key, required this.selectedFiles});

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  List<File> files = [];
  @override
  void initState() {
    files = widget.selectedFiles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Images'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: files.length + 1, // Add 1 for the "+" button
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () async {
                      List<File> temps = await pickImage();
                      files.addAll(temps);
                      setState(() {});
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  final imageIndex = index - 1; // Adjust for the "+" button
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.file(files[imageIndex], fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            files.removeAt(imageIndex);
                            setState(() {});
                          },
                          child: AppAssets.svgMinus,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(files);
          },
          child: Text('DONE', style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}

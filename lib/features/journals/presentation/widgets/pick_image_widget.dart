import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/image_picker_utils.dart';
import 'package:onceinmind/features/journals/data/models/journal_attachment.dart';

class PickImageWidget extends StatefulWidget {
  final List<JournalAttachment> selectedAttachments;
  const PickImageWidget({super.key, required this.selectedAttachments});

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  List<JournalAttachment> attachments = [];
  @override
  void initState() {
    attachments = List<JournalAttachment>.from(widget.selectedAttachments);
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
              itemCount: attachments.length + 1, // Add 1 for the "+" button
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () async {
                      final temps = await pickImage();
                      attachments.addAll(
                        temps.map((file) => JournalAttachment.local(file)),
                      );
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
                        child: _buildPreview(attachments[imageIndex]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            attachments.removeAt(imageIndex);
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
            Navigator.of(
              context,
            ).pop(List<JournalAttachment>.from(attachments));
          },
          child: Text('DONE', style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }

  Widget _buildPreview(JournalAttachment attachment) {
    if (attachment.isRemote) {
      return CachedNetworkImage(
        imageUrl: attachment.signedUrl ?? '',
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }

    if (attachment.file != null) {
      return Image.file(attachment.file!, fit: BoxFit.cover);
    }

    return const Icon(Icons.image, size: 32);
  }
}

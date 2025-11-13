import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/image_picker_utils.dart';
import 'package:onceinmind/features/journals/data/models/journal_attachment.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/custom_child_fab.dart';
import 'package:onceinmind/features/journals/presentation/widgets/pick_image_widget.dart';

class GalleryButton extends StatefulWidget {
  final Function(List<JournalAttachment> selectedAttachments) onPressed;
  final List<JournalAttachment> attachments;
  const GalleryButton({
    super.key,
    required this.onPressed,
    required this.attachments,
  });

  @override
  State<GalleryButton> createState() => _GalleryButtonState();
}

class _GalleryButtonState extends State<GalleryButton> {
  List<JournalAttachment> selectedAttachments = [];
  @override
  void initState() {
    selectedAttachments = List<JournalAttachment>.from(widget.attachments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomChildFab(
      heroTag: 'btn1',
      child: selectedAttachments.isEmpty
          ? AppAssets.svgGallery
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _buildPreview(selectedAttachments.first),
            ),
      onPressed: () async {
        if (selectedAttachments.isEmpty) {
          final newFiles = await pickImage();
          selectedAttachments = newFiles
              .map((file) => JournalAttachment.local(file))
              .toList();
        } else {
          final result = await showDialog<List<JournalAttachment>>(
            context: context,
            builder: (ctx) {
              return PickImageWidget(selectedAttachments: selectedAttachments);
            },
          );
          if (result != null) {
            selectedAttachments = result;
          }
        }
        widget.onPressed(List<JournalAttachment>.from(selectedAttachments));

        setState(() {});
      },
    );
  }

  Widget _buildPreview(JournalAttachment attachment) {
    if (attachment.isRemote) {
      return CachedNetworkImage(
        imageUrl: attachment.signedUrl ?? '',
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => AppAssets.svgGallery,
      );
    }

    if (attachment.file != null) {
      return Image.file(attachment.file!, fit: BoxFit.cover);
    }

    return AppAssets.svgGallery;
  }
}

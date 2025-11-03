import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';

class CustomSliderWidget extends StatelessWidget {
  final JournalModel journal;
  final VoidCallback? onTap;
  final int? initialPage;
  final void Function(int value) onPageChanged;
  final BoxFit imageFit;
  const CustomSliderWidget({
    super.key,
    required this.journal,
    this.initialPage,
    this.onTap,
    this.imageFit = BoxFit.cover,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      initialPage: initialPage ?? 0,
      indicatorColor: Colors.white,
      indicatorBackgroundColor: Colors.grey.withOpacity(0.5),
      onPageChanged: (value) => onPageChanged(value),
      children: journal.imagesUrls
          .map(
            (imageUrl) => InkWell(
              onTap: onTap,
              child: Hero(
                tag: journal.id,
                child: CachedNetworkImage(
                  fit: imageFit,
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      Container(color: Colors.black12),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

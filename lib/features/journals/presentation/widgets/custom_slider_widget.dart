import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';

class CustomSliderWidget extends StatelessWidget {
  final JournalModel journal;
  final VoidCallback? onTap;
  final int initialPage;
  final void Function(int value) onPageChanged;
  final BoxFit imageFit;
  const CustomSliderWidget({
    super.key,
    required this.journal,
    required this.initialPage,
    this.onTap,
    this.imageFit = BoxFit.cover,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      // key: ValueKey(
      //   'slideshow_$initialPage',
      // ), // Force rebuild when initialPage changes
      initialPage: initialPage,
      indicatorColor: AppColors.primaryColor,
      indicatorBackgroundColor:
          AppColors.hintColor, //Colors.grey.withOpacity(0.5)
      onPageChanged: (value) => onPageChanged(value),
      children: journal.signedUrls!
          .map(
            (signedUrl) => InkWell(
              onTap: onTap,
              child: CachedNetworkImage(
                fit: imageFit,
                imageUrl: signedUrl,
                placeholder: (context, url) =>
                    Container(color: AppColors.shadowColor),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          )
          .toList(),
    );
  }
}

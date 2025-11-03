import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/widgets/custom_slider_widget.dart';

class ImageViewerPage extends StatelessWidget {
  ImageViewerPage({
    super.key,
    required this.journal,
    required this.initialIndex,
  });
  final JournalModel journal;
  final int initialIndex;
  int? currentIndex;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onVerticalDragEnd: (details) =>
              context.pop(currentIndex ?? initialIndex),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      context.pop(currentIndex ?? initialIndex);
                    },
                    child: Icon(
                      Icons.close,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomSliderWidget(
                  journal: journal,
                  imageFit: BoxFit.contain,
                  initialPage: initialIndex,
                  onPageChanged: (value) {
                    currentIndex = value;
                    print(currentIndex);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

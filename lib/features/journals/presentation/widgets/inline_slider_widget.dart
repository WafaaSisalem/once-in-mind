import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/type_defs.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/widgets/custom_slider_widget.dart';

class InlineSliderWidget extends StatelessWidget {
  final JournalModel journal;
  InlineSliderWidget({super.key, required this.journal});
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      width: double.infinity,
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x28000000), //
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomSliderWidget(
        onPageChanged: (value) {
          currentIndex = value;
        },
        journal: journal,
        onTap: () async {
          ImageInSlider extras = (journal: journal, initialIndex: currentIndex);
          currentIndex =
              await context.pushNamed<int?>(
                AppRoutes.imageViewerPage,
                extra: extras,
              ) ??
              currentIndex;
        },
      ),
    );
  }
}

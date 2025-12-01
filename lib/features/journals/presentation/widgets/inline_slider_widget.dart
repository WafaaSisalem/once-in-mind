import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/image_slider_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/custom_slider_widget.dart';

class InlineSliderWidget extends StatelessWidget {
  final JournalModel journal;
  const InlineSliderWidget({super.key, required this.journal});

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
            color: AppColors.shadowColor, //
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: BlocBuilder<ImageSliderCubit, int>(
        builder: (context, state) {
          print(' InlineSlider rebuilt');

          return CustomSliderWidget(
            initialPage: state,
            onPageChanged: (value) {
              context.read<ImageSliderCubit>().setCurrentIndex(value);
            },
            journal: journal,
            onTap: () {
              context.pushNamed(AppRoutes.imageViewerPage, extra: journal);
              // Use Navigator.push to avoid parent route rebuild
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ImageViewerPage(journal: journal),
              //     fullscreenDialog: true,
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}

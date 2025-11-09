import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/image_slider_cubit.dart';
import 'package:onceinmind/features/journals/presentation/widgets/custom_slider_widget.dart';

class ImageViewerPage extends StatelessWidget {
  ImageViewerPage({super.key, required this.journal});
  final JournalModel journal;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onVerticalDragEnd: (details) => context.pop(),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
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
                child: BlocBuilder<ImageSliderCubit, int>(
                  builder: (context, state) {
                    return CustomSliderWidget(
                      onPageChanged: (value) {
                        context.read<ImageSliderCubit>().setCurrentIndex(value);
                      },
                      imageFit: BoxFit.contain,
                      initialPage: state,

                      journal: journal,
                    );
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

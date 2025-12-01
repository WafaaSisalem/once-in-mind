import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/constants/app_keys.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/journals/presentation/widgets/fallback_widget.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsCubit, JournalsState>(
      builder: (context, state) {
        if (state is JournalsLoaded) {
          //get all images from all journals
          final allSignedUrls = state.journals.expand((journal) {
            //if journal is locked then its images won't display so return []
            final images = journal.isLocked ? [] : journal.signedUrls ?? [];

            return images.map(
              (img) => {AppKeys.id: journal.id, AppKeys.imageUrl: img},
            );
          }).toList();

          return allSignedUrls.isEmpty
              ? Center(
                  child: FallbackWidget(
                    text: 'No images attached to journals',
                    image: AppAssets.svgNoJournalImages,
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                  child: GridView.builder(
                    // padding: EdgeInsets.symmetric(horizontal: 36.w),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: allSignedUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          JournalModel? journal = context
                              .read<JournalsCubit>()
                              .getJournalById(allSignedUrls[index][AppKeys.id]);
                          context.goNamed(
                            AppRoutes.displayJournal,
                            extra: journal,
                          );
                        },
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor, //
                                offset: Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: allSignedUrls[index][AppKeys.imageUrl]!,
                            placeholder: (context, url) =>
                                Container(color: Colors.black12),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                );
        } else {
          return Center(
            child: FallbackWidget(
              text: 'Could not load images',
              image: AppAssets.svgNoJournalImages,
            ),
          );
        }
      },
    );
  }
}

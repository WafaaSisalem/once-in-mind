import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_state.dart';
import 'package:onceinmind/features/journals/presentation/widgets/fallback_widget.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JournalsCubit>().state;
    final allSignedUrls = (state is JournalsLoaded)
        ? state.journals.expand((journal) => journal.signedUrls ?? []).toList()
        : [];
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: allSignedUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    //get the journal id for the image then navigate to display screen
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x28000000), //
                          offset: Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: allSignedUrls[index],
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
  }
}

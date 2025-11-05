import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/status_button.dart';

class CustomExpandableFab extends StatelessWidget {
  CustomExpandableFab({super.key});

  @override
  Widget build(BuildContext context) {
    print('customexpafa');
    final theme = Theme.of(context);
    return ExpandableFab(
      initialOpen: true,
      openButtonBuilder: buildOpenBtn(), //Done
      closeButtonBuilder: buildCloseBtn(), // Done
      children: [
        buildGalleryBtn(),
        buildMapBtn(),
        buildWeatherBtn(theme),
        StatusButton(),
      ],
    );
  }

  FloatingActionButton buildWeatherBtn(ThemeData theme) {
    return FloatingActionButton(
      shape: const CircleBorder(),

      heroTag: 'btn3',
      backgroundColor: Colors.white,
      child: AppAssets.svgWeather,
      // child: journalProvider.formatedCelsius == ''
      //     ? ColorFiltered(
      //         colorFilter: const ColorFilter.mode(
      //           Colors.grey,
      //           BlendMode.srcIn,
      //         ),
      //         child: AppAssets.svgWeather,
      //       )
      //     : Text(
      //         journalProvider.formatedCelsius,
      //         style: theme.textTheme.displaySmall!
      //             .copyWith(color: theme.primaryColor),
      //       ),
      onPressed: () {},
    );
  }

  FloatingActionButton buildMapBtn() {
    return FloatingActionButton(
      shape: const CircleBorder(),

      heroTag: 'btn2',
      backgroundColor: Colors.white,
      child: AppAssets.svgMap,
      // child: journalProvider.location == null ? AppAssets.svgMap:AppAssets. svgMapDone,
      onPressed: () {},
    );
  }

  FloatingActionButton buildGalleryBtn() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      heroTag: 'btn1',
      backgroundColor: Colors.white,
      child: AppAssets.svgGallery,
      // child: journalProvider
      //         .pickedImages.isEmpty // journalProvider.filesPicked.isEmpty
      //     ?AppAssets. svgGallery
      //     : SizedBox(
      //         width: double.infinity,
      //         height: double.infinity,

      //         child: journalProvider.pickedImages[0],

      //         // child: Image.file(
      //         //   journalProvider.filesPicked[0],
      //         //   fit: BoxFit.cover,
      //         // ),
      //       ),
      onPressed: () {
        //  onGalleryBtnPressed();
      },
    );
  }

  FloatingActionButtonBuilder buildCloseBtn() {
    return FloatingActionButtonBuilder(
      builder: (context, onPressed, progress) => FabWidget(
        heroTag: 'close btn',
        onPressed: onPressed!,
        icon: Icons.close_rounded,
      ),
      size: 20,
    );
  }

  //  onGalleryBtnPressed() async {
  //     if (journalProvider.pickedImages.isEmpty) {
  //       List<File> files = await journalProvider
  //           .selectFiles(); //THIS METHOD ADDS FILES TO pickedImages in provider
  //       pickedFiles.addAll(files);
  //       setState(() {});
  //     } else {
  //       showDialog(
  //           context: context,
  //           builder: (ctx) {
  //             return Consumer<JournalProvider>(
  //                 builder: (context, journalProviderIn, x) {
  //               return PickImageWidget(
  //                   images: journalProviderIn.pickedImages,
  //                   onRemovePressed: (index) {
  //                     journalProviderIn.removeImageAt(index);
  //                     pickedFiles.removeAt(index);
  //                   },
  //                   onAddImagePressed: (files) {
  //                     journalProviderIn.addImages(files);
  //                     pickedFiles.addAll(files);
  //                   },
  //                   onDonePressed: (files) {
  //                     context.pop();
  //                   });
  //             });
  //           });
  //     }
  //   }
  FloatingActionButtonBuilder buildOpenBtn() {
    return FloatingActionButtonBuilder(
      builder: (context, onPressed, progress) =>
          FabWidget(onPressed: onPressed!, heroTag: 'open btn '),
      size: 20,
    );
  }

  //     onMapBtnPressed() {
  //     ThemeData theme = Theme.of(context);
  //     showDialog(
  //         context: context,
  //         builder: (ctx) {
  //           return AlertDialog(
  //             title: const Text(
  //               'No Location Detected...',
  //             ),
  //             content: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextButton.icon(
  //                     onPressed: () async {
  //                      context.pop();
  //                       journalProvider.location = await AppRouter.router
  //                           .pushFunction(const MapScreen());
  //                       setState(() {});
  //                     },
  //                     icon: Icon(
  //                       Icons.add_location_alt_rounded,
  //                       color: theme.primaryColor,
  //                     ),
  //                     label: Text(
  //                       'Pick a Place',
  //                       style: theme.textTheme.headlineMedium,
  //                     )),
  //                 TextButton.icon(
  //                     onPressed: () {
  //                       journalProvider.getLocation();
  //                       context.pop();
  //                     },
  //                     icon: Icon(
  //                       Icons.gps_fixed,
  //                       color: theme.primaryColor,
  //                     ),
  //                     label: Text(
  //                       'Setup GPS',
  //                       style: theme.textTheme.headlineMedium,
  //                     )),
  //                 if (journalProvider.location != null)
  //                   TextButton.icon(
  //                       onPressed: () {
  //                         journalProvider.location = null;
  //                         setState(() {});
  //                         context.pop();
  //                       },
  //                       icon: Icon(
  //                         Icons.location_off,
  //                         color: theme.primaryColor,
  //                       ),
  //                       label: Text(
  //                         'Remove Location',
  //                         style: theme.textTheme.headlineMedium,
  //                       )),
  //               ],
  //             ),
  //           );
  //         });
  //   }
}

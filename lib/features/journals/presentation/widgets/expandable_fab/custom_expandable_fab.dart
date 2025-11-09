import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/gallery_button.dart';
import 'package:onceinmind/features/journals/presentation/widgets/expandable_fab/status_button.dart';

class CustomExpandableFab extends StatelessWidget {
  final Function(Status status) onStatusChanged;
  final Function(List<File> urls) onImageSelected;
  const CustomExpandableFab({
    super.key,
    required this.onStatusChanged,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    print('CustomExpandableFab rebuilt');
    final theme = Theme.of(context);
    return ExpandableFab(
      initialOpen: true,
      openButtonBuilder: buildOpenBtn(), //Done
      closeButtonBuilder: buildCloseBtn(), // Done
      children: [
        GalleryButton(
          onPressed: (files) {
            onImageSelected(files);
          },
        ),
        buildMapBtn(),
        buildWeatherBtn(theme),
        StatusButton(
          onPressed: (status) {
            onStatusChanged(status);
          },
        ),
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

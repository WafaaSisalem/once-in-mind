import 'package:flutter/material.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/type_defs.dart';
import 'package:onceinmind/features/calendar/presentation/pages/calendar_tab.dart';
import 'package:onceinmind/features/gallery/presentation/pages/gallery_tab.dart';
import 'package:onceinmind/features/journals/presentation/pages/journals_tab.dart';
import 'package:onceinmind/features/location/presentation/pages/location_tab.dart';

List<TabModel> tabs = [
  (
    content: const JournalsTab(),
    title: 'Home Page',
    iconPath: AppAssets.allJournals,
  ),
  (
    content: const CalendarTab(),
    title: 'Calendar',
    iconPath: AppAssets.calendar,
  ),
  (content: const LocationTab(), title: 'Location', iconPath: AppAssets.map),
  (content: const GalleryTab(), title: 'Gallery', iconPath: AppAssets.gallery),
];

class LocationTab extends StatelessWidget {
  const LocationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

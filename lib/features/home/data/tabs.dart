import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/utils/type_defs.dart';
import 'package:onceinmind/features/journals/presentation/pages/journals_tab.dart';

List<TabModel> tabs = [
  (
    content: const JournalsTab(),
    title: 'Home Page',
    iconPath: AppAssets.allJournals,
  ),
  (
    content: const CalendarPage(),
    title: 'Calendar',
    iconPath: AppAssets.calendar,
  ),
  (content: const MapPage(), title: 'Location', iconPath: AppAssets.map),
  (content: const GalleryPage(), title: 'Gallery', iconPath: AppAssets.gallery),
];

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/type_defs.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_in_page.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_up_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';
import 'package:onceinmind/features/home/presentation/pages/home_page.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/pages/add_journal_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/display_journal_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/edit_journal_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/image_viewer_page.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/${AppRoutes.signIn}',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;
      final loggingIn =
          state.fullPath == '/${AppRoutes.signIn}' ||
          state.fullPath == '/${AppRoutes.signUp}';

      if (authState is AuthSignedIn && loggingIn) {
        return '/${AppRoutes.home}';
      }

      if (authState is AuthSignedOut && !loggingIn) {
        return '/${AppRoutes.signIn}';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/${AppRoutes.signIn}',
        name: AppRoutes.signIn,
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: '/${AppRoutes.signUp}',
        name: AppRoutes.signUp,
        builder: (context, state) => SignUpPage(),
      ),

      // Main app routes
      GoRoute(
        path: '/${AppRoutes.home}',
        name: AppRoutes.home,
        builder: (context, state) => HomePage(),
        routes: [
          //Add journal Screen
          GoRoute(
            path: AppRoutes.addJournal,
            name: AppRoutes.addJournal,
            builder: (context, state) => AddJournalPage(),
          ),

          //display journal Screen
          GoRoute(
            path: AppRoutes.displayJournal,
            name: AppRoutes.displayJournal,
            routes: [
              //edit journal Screen
              GoRoute(
                path: AppRoutes.editJournal,
                name: AppRoutes.editJournal,
                builder: (context, state) =>
                    EditJournalPage(journal: state.extra as JournalModel),
              ),
              GoRoute(
                path: AppRoutes.imageViewerPage,
                name: AppRoutes.imageViewerPage,
                builder: (context, state) {
                  ImageInSlider data = state.extra as ImageInSlider;
                  final journal = data.journal;
                  final initialIndex = data.initialIndex;
                  return ImageViewerPage(
                    journal: journal,
                    initialIndex: initialIndex,
                  );
                },
              ),
            ],
            builder: (context, state) {
              final journal = state.extra as JournalModel;
              return DisplayJournalPage(
                journal: JournalModel(
                  id: 'id',
                  imagesUrls: [
                    'https://images.unsplash.com/photo-1615912844755-bd8b6dd6789e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=387',
                    'https://blog.adobe.com/en/publish/2024/10/14/media_1ca79b205381242c5f8beaaee2f0e1cfb2aa8f324.png?width=2000&format=webply&optimize=medium',
                    'https://images.unsplash.com/photo-1579037199070-5ddf23c52bfc?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=327',
                  ],
                  content:
                      'when the days are cold and the cards all fold and the saints we see are all made of gold. when the dreams all failed and the one we hail are the worst of all and the bloods run stail',
                  date: DateTime.now(),
                  isLocked: false,
                  location: LocationModel(22, 22, 'address'),
                ),
                // journal: journal,
              );
            },
          ),
        ],
      ),

      // GoRoute(
      //   path: 'detail/:id',
      //   name: 'journal-detail',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return EntryDetailPage(entryId: id);
      //   },
      // ),

      // Calendar route
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarPage(),
      ),

      // Search route
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),

      // Gallery route
      GoRoute(
        path: '/gallery',
        name: 'gallery',
        builder: (context, state) => const GalleryPage(),
      ),

      // Map route
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapPage(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );

  static GoRouter get router => _router;
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Calendar Page')));
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Search Page')));
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Gallery Page')));
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Map Page')));
}

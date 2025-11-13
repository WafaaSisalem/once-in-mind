import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_in_page.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_up_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';
import 'package:onceinmind/features/home/presentation/pages/home_page.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/pages/display_journal_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/image_viewer_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/journal_editor_page.dart';
import 'package:onceinmind/features/location/presentation/pages/location_page.dart';

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
            routes: [
              GoRoute(
                path: AppRoutes.location,
                name: AppRoutes.location,
                builder: (context, state) => const LocationPage(),
              ),
            ],
            builder: (context, state) => JournalEditorPage(),
            // builder: (context, state) => AddJournalPage(),
            // path: AppRoutes.addJournal,
            // name: AppRoutes.addJournal,
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
                    JournalEditorPage(journal: state.extra as JournalModel),
                // builder: (context, state) =>
                //     EditJournalPage(journal: state.extra as JournalModel),
              ),
              GoRoute(
                path: AppRoutes.imageViewerPage,
                name: AppRoutes.imageViewerPage,
                builder: (context, state) {
                  JournalModel journal = state.extra as JournalModel;
                  return ImageViewerPage(journal: journal);
                },
              ),
            ],
            builder: (context, state) {
              final journal = state.extra as JournalModel;
              return DisplayJournalPage(journal: journal);
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

      // Search route
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );

  static GoRouter get router => _router;
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Search Page')));
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/features/auth/presentation/pages/onboarding_page.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_in_page.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_up_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';
import 'package:onceinmind/features/home/presentation/pages/home_page.dart';
import 'package:onceinmind/features/home/presentation/pages/search_page.dart';
import 'package:onceinmind/features/journals/data/models/journal_model.dart';
import 'package:onceinmind/features/journals/presentation/pages/display_journal_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/image_viewer_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/journal_editor_page.dart';
import 'package:onceinmind/features/journals/presentation/pages/masterpass_page.dart';
import 'package:onceinmind/features/location/presentation/pages/location_page.dart';
import 'package:onceinmind/services/sharedpref_service.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/${AppRoutes.onboarding}',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // Check onboarding status first
      final isOnboardingCompleted =
          await OnboardingService.isOnboardingCompleted();
      final isOnboardingPage = state.fullPath == '/${AppRoutes.onboarding}';

      if (!isOnboardingCompleted && !isOnboardingPage) {
        return '/${AppRoutes.onboarding}';
      }

      if (isOnboardingCompleted && isOnboardingPage) {
        return '/${AppRoutes.signIn}';
      }

      if (isOnboardingCompleted) {
        final authState = context
            .read<AuthCubit>()
            .state; //you can store this in shared pref
        final loggingIn =
            state.fullPath == '/${AppRoutes.signIn}' ||
            state.fullPath == '/${AppRoutes.signUp}';

        if (authState is AuthSignedIn && loggingIn) {
          return '/${AppRoutes.home}';
        }

        if (authState is AuthSignedOut && !loggingIn && !isOnboardingPage) {
          return '/${AppRoutes.signIn}';
        }
      }

      return null;
    },
    routes: [
      // Onboarding route
      GoRoute(
        path: '/${AppRoutes.onboarding}',
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
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
          // Search route
          GoRoute(
            path: AppRoutes.search,
            name: AppRoutes.search,
            builder: (context, state) => const SearchPage(),
          ),
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
              ),
              GoRoute(
                path: AppRoutes.imageViewerPage,
                name: AppRoutes.imageViewerPage,
                builder: (context, state) {
                  JournalModel journal = state.extra as JournalModel;
                  return ImageViewerPage(journal: journal);
                },
              ),
              GoRoute(
                path: AppRoutes.masterPassword,
                name: AppRoutes.masterPassword,
                builder: (context, state) =>
                    MasterPassScreen(journal: state.extra as JournalModel),
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
    ],

    // Error page
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );

  static GoRouter get router => _router;
}

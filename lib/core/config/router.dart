import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_in_page.dart';
import 'package:onceinmind/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth_state.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/sign-up',
    debugLogDiagnostics: true,
    routes: [
      // Auth routes
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        builder: (context, state) => SignUpPage(),
      ),

      // Main app routes (protected)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Journal routes
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const JournalPage(),
        routes: [
          GoRoute(
            path: 'editor',
            name: 'journal-editor',
            builder: (context, state) => const EntryEditorPage(),
          ),
          GoRoute(
            path: 'detail/:id',
            name: 'journal-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EntryDetailPage(entryId: id);
            },
          ),
        ],
      ),

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignedOut) {
            // لما المستخدم يسجل خروج، نرجعه لشاشة تسجيل الدخول
            context.go('/sign-in');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: const Center(
          child: Text(
            'Welcome to Home Page 🎉',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Journal Page')));
}

class EntryEditorPage extends StatelessWidget {
  const EntryEditorPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Entry Editor Page')));
}

class EntryDetailPage extends StatelessWidget {
  final String entryId;
  const EntryDetailPage({super.key, required this.entryId});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Entry Detail: $entryId')));
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

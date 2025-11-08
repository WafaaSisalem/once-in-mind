import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onceinmind/core/config/router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/features/auth/data/repositories/auth_repository.dart';
import 'package:onceinmind/features/auth/data/repositories/user_repository.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/user/user_cubit.dart';
import 'package:onceinmind/features/journals/data/repositories/journal_repository.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.remove();
  await Supabase.initialize(
    url: 'https://loadxhdwkmzzuwnuvqwn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvYWR4aGR3a216enV3bnV2cXduIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNzcyNjAsImV4cCI6MjA3Nzk1MzI2MH0.eU0YDsexoHW2fDy4Dj58dh6N12NepDOZOSVHQWEdF-o',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();
  final JournalRepository _journalRepository = JournalRepository();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return AuthCubit(_authRepository);
          },
        ),
        BlocProvider(
          create: (_) {
            return UserCubit(_userRepository);
          },
        ),
        BlocProvider(
          create: (context) {
            return JournalsCubit(_journalRepository, _authRepository)
              ..fetchJournals();
          },
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

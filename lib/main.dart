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

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.remove();
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
        BlocProvider(create: (_) => AuthCubit(_authRepository)),
        BlocProvider(create: (_) => UserCubit(_userRepository)),
        if (_authRepository.currentUser != null)
          BlocProvider(
            create: (_) => JournalsCubit(
              _journalRepository,
              _authRepository.currentUser!.uid,
            )..fetchJournals(),
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

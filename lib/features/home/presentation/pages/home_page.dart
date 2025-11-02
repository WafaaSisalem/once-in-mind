import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/widgets/toast.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';
import 'package:onceinmind/features/home/data/tabs.dart';
import 'package:onceinmind/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';
import 'package:onceinmind/core/widgets/appbar_widget.dart';
import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [SizedBox(width: 20), Text(tabs[currentIndex].title)],
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: AppColors.white,
            onSelected: (value) {
              context.read<JournalsCubit>().resetState();
              context.read<AuthCubit>().signOut();
            },
            itemBuilder: (BuildContext context) {
              return {'Sign Out'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.white),
          ),

          SizedBox(width: 20),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignedOut) {
            context.goNamed(AppRoutes.signIn);
          } else if (state is AuthError) {
            showMyToast(message: state.message, context: context);
          }
        },
        child: tabs[currentIndex].content,
      ),
      bottomNavigationBar: BottomNavWidget(
        svgs: [
          tabs[0].iconPath,
          tabs[1].iconPath,
          tabs[2].iconPath,
          tabs[3].iconPath,
        ],
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FabWidget(
        onPressed: () {
          context.goNamed(AppRoutes.addJournal);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/widgets/toast.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';
// import 'package:onceinmind/features/home/data/tab_model.dart';
import 'package:onceinmind/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';
import 'package:onceinmind/core/widgets/home_appbar.dart';
import 'package:onceinmind/features/journals/presentation/pages/journals_page.dart';

typedef TabModel = ({Widget content, dynamic title, String iconPath});

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<TabModel> tabs = [
      (
        content: const JournalsPage(),
        title: 'Home Page',
        iconPath: 'assets/images/svgs/all_journal.svg',
      ),
      (
        content: const JournalsPage(),
        title: 'Calendar',
        iconPath: 'assets/images/svgs/calendar.svg',
      ),
      (
        content: const MapPage(),
        title: 'Location',
        iconPath: 'assets/images/svgs/map.svg',
      ),
      (
        content: const GalleryPage(),
        title: 'Gallery',
        iconPath: 'assets/images/svgs/gallery.svg',
      ),
    ];
    return Scaffold(
      appBar: AppbarWidget(
        titlePlace: Row(
          children: [SizedBox(width: 20), Text(tabs[currentIndex].title)],
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: AppColors.white,
            onSelected: (value) {
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
            context.go('/sign-in');
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
          context.go('/home/add-journal');
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:onceinmind/core/config/theme.dart';
// import 'package:onceinmind/core/widgets/toast.dart';
// import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_cubit.dart';
// import 'package:onceinmind/features/auth/presentation/cubits/auth/auth_state.dart';
// import 'package:onceinmind/features/home/presentation/widgets/bottom_nav_widget.dart';
// import 'package:onceinmind/features/home/presentation/widgets/fab_widget.dart';
// import 'package:onceinmind/core/widgets/home_appbar.dart';
// import 'package:onceinmind/features/journals/presentation/pages/journals_page.dart';
// import 'package:onceinmind/features/journals/presentation/cubits/journals_cubit.dart';
// import 'package:onceinmind/features/journals/data/repositories/journal_repository.dart';

// typedef TabModel = ({Widget content, dynamic title, String iconPath});

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final authState = context.watch<AuthCubit>().state;
//     final userId = authState is AuthSignedIn ? authState.user.uid : '';

//     List<TabModel> tabs = [
//       (
//         content: const JournalsPage(),
//         title: 'Home Page',
//         iconPath: 'assets/images/svgs/all_journal.svg',
//       ),
//       (
//         content: const JournalsPage(),
//         title: 'Calendar',
//         iconPath: 'assets/images/svgs/calendar.svg',
//       ),
//       (
//         content: const MapPage(),
//         title: 'Location',
//         iconPath: 'assets/images/svgs/map.svg',
//       ),
//       (
//         content: const GalleryPage(),
//         title: 'Gallery',
//         iconPath: 'assets/images/svgs/gallery.svg',
//       ),
//     ];

//     return BlocProvider(
//       create: (_) =>
//           JournalsCubit(JournalRepository(), userId)..fetchJournals(),
//       child: Scaffold(
//         appBar: AppbarWidget(
//           titlePlace: Row(
//             children: [
//               const SizedBox(width: 20),
//               Text(tabs[currentIndex].title),
//             ],
//           ),
//           actions: [
//             PopupMenuButton<String>(
//               iconColor: AppColors.white,
//               onSelected: (value) {
//                 context.read<AuthCubit>().signOut();
//               },
//               itemBuilder: (BuildContext context) {
//                 return {'Sign Out'}.map((String choice) {
//                   return PopupMenuItem<String>(
//                     value: choice,
//                     child: Text(choice),
//                   );
//                 }).toList();
//               },
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.search, color: AppColors.white),
//             ),
//             const SizedBox(width: 20),
//           ],
//         ),
//         body: BlocListener<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthSignedOut) {
//               context.go('/sign-in');
//             } else if (state is AuthError) {
//               showMyToast(message: state.message, context: context);
//             } else if (state is AuthSignedIn) {
//               // بمجرد تسجيل الدخول، نعمل fetch للجورنالات
//               context.read<JournalsCubit>().fetchJournals();
//             }
//           },
//           child: tabs[currentIndex].content,
//         ),
//         bottomNavigationBar: BottomNavWidget(
//           svgs: [
//             tabs[0].iconPath,
//             tabs[1].iconPath,
//             tabs[2].iconPath,
//             tabs[3].iconPath,
//           ],
//           onTap: (index) {
//             setState(() {
//               currentIndex = index;
//             });
//           },
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FabWidget(
//           onPressed: () {
//             context.go('/home/add-journal');
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:onceinmind/core/config/theme.dart';

class CustomChildFab extends StatelessWidget {
  final String heroTag;
  final Widget child;
  final VoidCallback onPressed;

  const CustomChildFab({
    super.key,
    required this.heroTag,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      clipBehavior: Clip.antiAliasWithSaveLayer,

      shape: const CircleBorder(),

      heroTag: heroTag,
      backgroundColor: AppColors.white,

      onPressed: onPressed,
      child: child,
    );
  }
}

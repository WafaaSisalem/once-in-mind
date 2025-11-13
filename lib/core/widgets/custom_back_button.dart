import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        size: 28,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}

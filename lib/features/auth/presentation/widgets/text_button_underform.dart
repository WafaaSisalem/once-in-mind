import 'package:flutter/material.dart';

class TextButtonUnderform extends StatelessWidget {
  const TextButtonUnderform.signIn({super.key, required this.onTap})
    : text = 'Forgot Password?';
  const TextButtonUnderform.signUp({super.key, required this.onTap})
    : text = 'I have an account';
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.87, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/utils/app_assets.dart';

class RegistrationUpperSection extends StatelessWidget {
  RegistrationUpperSection.signIn({super.key})
    : title = 'Sign In',
      subtitle = 'Sign in to continue',
      image = AppAssets.signIN;
  RegistrationUpperSection.signUp({super.key})
    : title = 'Sign Up',
      subtitle = 'Please enter your information below',
      image = AppAssets.signUp;

  final String title;
  final String subtitle;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        image,
        SizedBox(height: 25),
      ],
    );
  }
}

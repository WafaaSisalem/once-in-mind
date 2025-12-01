import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/constants/app_routes.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/services/sharedpref_service.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Upper section with text and button
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 80, top: 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'ONCE IN MIND',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'This is a space for you to express your feelings and share memories with your future self.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.only(right: 120),
                    child: ElevatedButton(
                      onPressed: () async {
                        await OnboardingService.completeOnboarding();
                        if (context.mounted) {
                          context.goNamed(AppRoutes.signIn);
                        }
                      },

                      child: Text('Get Started'),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom section with illustration
            Expanded(
              child: SizedBox(
                child: Image.asset(
                  AppAssets.onboarding,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

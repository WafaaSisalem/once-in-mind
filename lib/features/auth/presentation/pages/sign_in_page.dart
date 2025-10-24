import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/config/theme.dart';
import 'package:onceinmind/core/utils/app_assets.dart';
import 'package:onceinmind/core/widgets/toast.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth_state.dart';
import 'package:onceinmind/features/auth/presentation/widgets/registration_base.dart';
import 'package:onceinmind/features/auth/presentation/widgets/registration_form.dart';
import 'package:onceinmind/features/auth/presentation/widgets/text_button_underform.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  RegistrationUpperSection.signIn(),
                  RegistrationForm(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  TextButtonUnderform.signIn(
                    onTap: () {
                      //route to forget password page
                    },
                  ),
                  SizedBox(height: 30),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        showMyToast(context: context, message: state.message);
                      } else if (state is AuthSignedIn) {
                        context.go('/home');
                      }
                    },
                    builder: (context, state) {
                      return state is AuthLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                final email = emailController.text.trim();
                                final password = passwordController.text;
                                context.read<AuthCubit>().signIn(
                                  email,
                                  password,
                                );
                              },
                              child: Text('Sign In'),
                            );
                    },
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.grey300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.grey300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  OutlinedButton.icon(
                    icon: Image.asset(AppAssets.google, width: 25, height: 25),
                    onPressed: () {
                      //TODO
                    },
                    label: const Text('SIGN IN WITH GOOGLE'),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.go('/sign-up');
                    },
                    child: Text(
                      'Create account',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

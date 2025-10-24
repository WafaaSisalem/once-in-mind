import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onceinmind/core/widgets/toast.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:onceinmind/features/auth/presentation/cubits/auth_state.dart';
import 'package:onceinmind/features/auth/presentation/widgets/registration_base.dart';
import 'package:onceinmind/features/auth/presentation/widgets/registration_form.dart';
import 'package:onceinmind/features/auth/presentation/widgets/text_button_underform.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
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
                  RegistrationUpperSection.signUp(),
                  RegistrationForm(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  TextButtonUnderform.signUp(
                    onTap: () {
                      context.go('/sign-in');
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
                      return ElevatedButton(
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text;
                          context.read<AuthCubit>().signUp(email, password);
                        },
                        child: state is AuthLoading
                            ? CircularProgressIndicator()
                            : Text('Sign Up'),
                      );
                    },
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

import 'package:flutter/material.dart';
import 'package:onceinmind/core/utils/toast.dart';
import 'package:onceinmind/features/auth/presentation/widgets/form_text_field.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextFieldWidget(
            controller: emailController,
            hint: 'Email',

            keyboardType: TextInputType.emailAddress,
          ),
          CustomTextFieldWidget(
            hint: 'Password',
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            controller: passwordController,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}

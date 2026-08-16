import 'package:flutter/material.dart';
import 'auth_form.dart';

@Deprecated('Use AuthForm instead')
class EmailPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final VoidCallback? onSubmitted;

  const EmailPasswordForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AuthForm(
      showNameField: false,
      emailController: emailController,
      passwordController: passwordController,
      emailError: emailError,
      passwordError: passwordError,
      onEmailChanged: onEmailChanged,
      onPasswordChanged: onPasswordChanged,
      onSubmitted: onSubmitted,
    );
  }
}

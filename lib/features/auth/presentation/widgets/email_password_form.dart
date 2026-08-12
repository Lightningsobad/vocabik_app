import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/password_input_widget.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  const EmailPasswordForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    this.onEmailChanged,
    this.onPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Email
        TextField(
          controller: emailController,
          onChanged: onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.nunito(
            color: colors?.textPrimary,
            fontSize: 16,
          ),
          cursorColor: const Color(0xFF06B6D4),
          decoration: InputDecoration(
            hintText: 'Email của bạn',
            hintStyle: GoogleFonts.nunito(color: colors?.textSecondary),
            filled: true,
            fillColor: colors?.background ?? Colors.grey.shade100,
            errorText: emailError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: colors?.borderSubtle ?? Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: colors?.borderSubtle ?? Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: colors?.danger ?? Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          ),
        ),
        const SizedBox(height: 14),
        // Password
        PasswordInputWidget(
          controller: passwordController,
          hintText: 'Mật khẩu',
          errorText: passwordError,
          onChanged: onPasswordChanged,
        ),
      ],
    );
  }
}

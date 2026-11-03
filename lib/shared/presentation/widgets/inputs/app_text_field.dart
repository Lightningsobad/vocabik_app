import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final TextAlign textAlign;
  final bool readOnly;
  final bool? enabled;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();

    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      textAlign: textAlign,
      readOnly: readOnly,
      enabled: enabled,
      style: GoogleFonts.nunito(
        color: colors?.textPrimary,
        fontSize: 16,
      ),
      cursorColor: colors?.primaryAccent,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(
          color: colors?.hintText ?? const Color(0xFF757575),
        ),
        filled: true,
        fillColor: colors?.inputBackground ?? Colors.grey.shade100,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colors?.inputBorder ?? Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colors?.inputBorder ?? Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colors?.primaryAccent ?? const Color(0xFF0891B2),
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colors?.danger ?? Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: colors?.danger ?? Colors.red,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 12.0,
        ),
      ),
    );
  }
}

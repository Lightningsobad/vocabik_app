import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Text Style generator for the Vocabik Design System.
/// If the app changes font family in the future, only change [fontFamily] or the base font method here.
class AppTextStyles {
  AppTextStyles._();

  /// Creates a standard [TextStyle] using the design system font (Nunito).
  static TextStyle custom({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height = 1.2,
    double? letterSpacing = 0,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}

/// Convenience extension on [BuildContext] to access design system typography with context defaults.
extension AppTypographyExtension on BuildContext {
  TextStyle appTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height = 1.2,
    double? letterSpacing = 0,
    TextDecoration? decoration,
  }) {
    return AppTextStyles.custom(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? Theme.of(this).colorScheme.onSurface,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final extension = AppColorsExtension.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: extension.background,
      primaryColor: AppColors.accent,
      colorScheme: ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.premium,
        surface: extension.surfaceCard,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: extension.textPrimary,
        displayColor: extension.textPrimary,
      ),
      extensions: [extension],
    );
  }

  static ThemeData get darkTheme {
    final extension = AppColorsExtension.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: extension.background,
      primaryColor: AppColors.accent,
      colorScheme: ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.premium,
        surface: extension.surfaceCard,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: extension.textPrimary,
        displayColor: extension.textPrimary,
      ),
      extensions: [extension],
    );
  }
}

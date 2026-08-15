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
      primaryColor: extension.primaryAccent,
      colorScheme: ColorScheme.light(
        primary: extension.primaryAccent,
        onPrimary: extension.onPrimaryAccent,
        secondary: AppColors.premium,
        surface: extension.surfaceCard,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: extension.surfaceCard,
        foregroundColor: extension.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: extension.borderSubtle,
        thickness: 1.0,
        space: 1.0,
      ),
      iconTheme: IconThemeData(
        color: extension.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: extension.primaryAccent,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: extension.borderSubtle,
            width: 1.0,
          ),
        ),
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
      primaryColor: extension.primaryAccent,
      colorScheme: ColorScheme.dark(
        primary: extension.primaryAccent,
        onPrimary: extension.onPrimaryAccent,
        secondary: AppColors.premium,
        surface: extension.surfaceCard,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: extension.surfaceCard,
        foregroundColor: extension.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: extension.borderSubtle,
        thickness: 1.0,
        space: 1.0,
      ),
      iconTheme: IconThemeData(
        color: extension.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: extension.primaryAccent,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: extension.borderSubtle,
            width: 1.0,
          ),
        ),
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: extension.textPrimary,
        displayColor: extension.textPrimary,
      ),
      extensions: [extension],
    );
  }
}

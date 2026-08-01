import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color ink950 = Color(0xFF0F172A);
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentBorder = Color(0xFF1E293B);
  static const Color premium = Color(0xFF8B5CF6);
  static const Color streak = Color(0xFFF59E0B);
  
  // Legacy colors (should be migrated to AppColorsExtension)
  static const Color surfaceCard2 = Color(0xFFF8FAFC);
  static const Color borderDefault = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textPrimary = Color(0xFF13131F);
  static Color get glassFill => Colors.white.withValues(alpha: 0.7);
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color background;
  final Color surfaceCard;
  final Color borderSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color glassFill;

  const AppColorsExtension({
    required this.background,
    required this.surfaceCard,
    required this.borderSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.glassFill,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? background,
    Color? surfaceCard,
    Color? borderSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? glassFill,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      glassFill: glassFill ?? this.glassFill,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
    );
  }

  static const light = AppColorsExtension(
    background: Color(0xFFFFFFFF),
    surfaceCard: Color(0xFFF8FAFC),
    borderSubtle: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF13131F),
    textSecondary: Color(0xFF64748B),
    glassFill: Color(0xB3FFFFFF), // Colors.white.withOpacity(0.7)
  );

  static const dark = AppColorsExtension(
    background: Color(0xFF0B0F19),
    surfaceCard: Color(0xFF1E293B),
    borderSubtle: Color(0xFF334155),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    glassFill: Color(0xB30B0F19), // Color(0xFF0B0F19).withOpacity(0.7)
  );
}

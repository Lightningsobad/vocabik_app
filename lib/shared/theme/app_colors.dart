import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color ink950 = Color(0xFF0F172A);
  static const Color accentBorder = Color(0xFF1E293B);
  static const Color premium = Color(0xFF8B5CF6);
  static const Color streak = Color(0xFFF59E0B);
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primaryAccent;
  final Color onPrimaryAccent;
  final Color tabUnselectedBackground;
  final Color tabUnselectedBorder;
  final Color tabUnselectedText;
  final Color navUnselected;
  final Color navSelected;
  final Color background;
  final Color surfaceCard;
  final Color borderSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color premiumBackground;
  final Color danger;
  final Color dangerSoft;
  final Color success;
  final Color successBackground;
  final Color successBorder;
  final Color optionCardBackground;
  final Color optionCardBorder;
  final Color inputBackground;
  final Color inputBorder;
  final Color socialBackground;
  final Color socialBorder;
  final Color hintText;
  final Color logoPlay;
  final Color logoBackground;
  final Color logoBorder;
  final Color logoUnderline;
  final Color infoSoft;

  const AppColorsExtension({
    required this.primaryAccent,
    required this.onPrimaryAccent,
    required this.tabUnselectedBackground,
    required this.tabUnselectedBorder,
    required this.tabUnselectedText,
    required this.navUnselected,
    required this.navSelected,
    required this.background,
    required this.surfaceCard,
    required this.borderSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.premiumBackground,
    required this.danger,
    required this.dangerSoft,
    required this.success,
    required this.successBackground,
    required this.successBorder,
    required this.optionCardBackground,
    required this.optionCardBorder,
    required this.inputBackground,
    required this.inputBorder,
    required this.socialBackground,
    required this.socialBorder,
    required this.hintText,
    required this.logoPlay,
    required this.logoBackground,
    required this.logoBorder,
    required this.logoUnderline,
    required this.infoSoft,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primaryAccent,
    Color? onPrimaryAccent,
    Color? tabUnselectedBackground,
    Color? tabUnselectedBorder,
    Color? tabUnselectedText,
    Color? navUnselected,
    Color? navSelected,
    Color? background,
    Color? surfaceCard,
    Color? borderSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? premiumBackground,
    Color? danger,
    Color? dangerSoft,
    Color? success,
    Color? successBackground,
    Color? successBorder,
    Color? optionCardBackground,
    Color? optionCardBorder,
    Color? inputBackground,
    Color? inputBorder,
    Color? socialBackground,
    Color? socialBorder,
    Color? hintText,
    Color? logoPlay,
    Color? logoBackground,
    Color? logoBorder,
    Color? logoUnderline,
    Color? infoSoft,
  }) {
    return AppColorsExtension(
      primaryAccent: primaryAccent ?? this.primaryAccent,
      onPrimaryAccent: onPrimaryAccent ?? this.onPrimaryAccent,
      tabUnselectedBackground:
          tabUnselectedBackground ?? this.tabUnselectedBackground,
      tabUnselectedBorder: tabUnselectedBorder ?? this.tabUnselectedBorder,
      tabUnselectedText: tabUnselectedText ?? this.tabUnselectedText,
      navUnselected: navUnselected ?? this.navUnselected,
      navSelected: navSelected ?? this.navSelected,
      background: background ?? this.background,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      premiumBackground: premiumBackground ?? this.premiumBackground,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      success: success ?? this.success,
      successBackground: successBackground ?? this.successBackground,
      successBorder: successBorder ?? this.successBorder,
      optionCardBackground: optionCardBackground ?? this.optionCardBackground,
      optionCardBorder: optionCardBorder ?? this.optionCardBorder,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      socialBackground: socialBackground ?? this.socialBackground,
      socialBorder: socialBorder ?? this.socialBorder,
      hintText: hintText ?? this.hintText,
      logoPlay: logoPlay ?? this.logoPlay,
      logoBackground: logoBackground ?? this.logoBackground,
      logoBorder: logoBorder ?? this.logoBorder,
      logoUnderline: logoUnderline ?? this.logoUnderline,
      infoSoft: infoSoft ?? this.infoSoft,
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
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      onPrimaryAccent: Color.lerp(onPrimaryAccent, other.onPrimaryAccent, t)!,
      tabUnselectedBackground: Color.lerp(
        tabUnselectedBackground,
        other.tabUnselectedBackground,
        t,
      )!,
      tabUnselectedBorder: Color.lerp(
        tabUnselectedBorder,
        other.tabUnselectedBorder,
        t,
      )!,
      tabUnselectedText: Color.lerp(
        tabUnselectedText,
        other.tabUnselectedText,
        t,
      )!,
      navUnselected: Color.lerp(navUnselected, other.navUnselected, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
      background: Color.lerp(background, other.background, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      premiumBackground: Color.lerp(
        premiumBackground,
        other.premiumBackground,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBackground: Color.lerp(
        successBackground,
        other.successBackground,
        t,
      )!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      optionCardBackground: Color.lerp(
        optionCardBackground,
        other.optionCardBackground,
        t,
      )!,
      optionCardBorder: Color.lerp(
        optionCardBorder,
        other.optionCardBorder,
        t,
      )!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      socialBackground: Color.lerp(socialBackground, other.socialBackground, t)!,
      socialBorder: Color.lerp(socialBorder, other.socialBorder, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      logoPlay: Color.lerp(logoPlay, other.logoPlay, t)!,
      logoBackground: Color.lerp(logoBackground, other.logoBackground, t)!,
      logoBorder: Color.lerp(logoBorder, other.logoBorder, t)!,
      logoUnderline: Color.lerp(logoUnderline, other.logoUnderline, t)!,
      infoSoft: Color.lerp(infoSoft, other.infoSoft, t)!,
    );
  }

  static const light = AppColorsExtension(
    primaryAccent: Color(0xFF0891B2),
    onPrimaryAccent: Color(0xFFFFFFFF),
    tabUnselectedBackground: Color(0xFFF5F5FA),
    tabUnselectedBorder: Color(0xFFE8E8ED),
    tabUnselectedText: Color(0xFF4B4B63),
    navUnselected: Color(0xFF6D6D87),
    navSelected: Color(0xFF088FB0),
    background: Color(0xFFF5F5FA),
    surfaceCard: Color(0xFFFFFFFF),
    borderSubtle: Color(0xFFF2F2F2),
    textPrimary: Color(0xFF13131F),
    textSecondary: Color(0xFF6D6D87),
    premiumBackground: Color(0xFFA854F7),
    danger: Color(0xFFE23E54),
    dangerSoft: Color(0x1AE23E54),
    success: Color(0xFF16B877),
    successBackground: Color(0xFFE1F5ED),
    successBorder: Color(0xFF16B877),
    optionCardBackground: Color(0xFFF5F5FA),
    optionCardBorder: Color(0xFFD7D7DE),
    inputBackground: Color(0xFFEDEDF5),
    inputBorder: Color(0xFFD2D2D9),
    socialBackground: Color(0xFFF5F5FA),
    socialBorder: Color(0xFFD7D7DE),
    hintText: Color(0xFF757575),
    logoPlay: Color(0xFF0790B3),
    logoBackground: Color(0xFF0D0D1A),
    logoBorder: Color(0xFF0B3145),
    logoUnderline: Color(0xFF9234EB),
    infoSoft: Color(0xFFE8F2FF),
  );

  static const dark = AppColorsExtension(
    primaryAccent: Color(0xFF00E5CC),
    onPrimaryAccent: Color(0xFF0D0D1A),
    tabUnselectedBackground: Color(0xFF20203B),
    tabUnselectedBorder: Color(0xFF303047),
    tabUnselectedText: Color(0xFFA6A6BF),
    navUnselected: Color(0xFF8585A1),
    navSelected: Color(0xFF00E6CB),
    background: Color(0xFF0D0D1A),
    surfaceCard: Color(0xFF1A1A2E),
    borderSubtle: Color(0xFF2A2A3D),
    textPrimary: Color(0xFFF5F5FA),
    textSecondary: Color(0xFF8585A1),
    premiumBackground: Color(0xFFA854F7),
    danger: Color(0xFFFF5C72),
    dangerSoft: Color(0x29FF5C72),
    success: Color(0xFF22D98C),
    successBackground: Color(0xFF153331),
    successBorder: Color(0xFF22D98C),
    optionCardBackground: Color(0xFF1E2238),
    optionCardBorder: Color(0xFF2A2F48),
    inputBackground: Color(0xFF13131F),
    inputBorder: Color(0xFF31313B),
    socialBackground: Color(0xFF20203B),
    socialBorder: Color(0xFF3B3B52),
    hintText: Color(0xFF757575),
    logoPlay: Color(0xFF00E6CB),
    logoBackground: Color(0xFF0D0D1A),
    logoBorder: Color(0xFF094D4F),
    logoUnderline: Color(0xFFA854F7),
    infoSoft: Color(0xFF22304F),
  );
}

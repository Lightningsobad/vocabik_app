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
  final Color warning;
  final Color warningSoft;
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
  final Color versionSelectedBackground;
  final Color versionSelectedBorder;
  final Color versionSubtitle;
  final Color shareText;
  final Color historyCardBackground;
  final Color historyCardBorder;
  final Color tagNewBackground;
  final Color tagNewText;
  final Color tagLevelA;
  final Color tagLevelB1;
  final Color tagLevelB2;
  final Color tagLevelC1;
  final Color tagLevelText;
  final Color tagCategoryBackground;
  final Color tagCategoryBorder;
  final Color videoDurationText;
  final Color hintButtonText;
  final Color scoreCardButtonBackground;
  final Color scoreCardButtonBorder;
  final Color xpCardBackground;
  final Color xpCardBorder;
  final Color streakCardBackground;
  final Color streakCardBorder;
  final Color badgeCardBackground;
  final Color badgeCardBorder;
  final Color accentCardBackground;
  final Color accentCardBorder;
  final Color streakCellActive;
  final Color streakCellInactive;
  final Color weeklyXpBarStart;
  final Color weeklyXpBarEnd;
  final Color levelProgressBar;
  final Color practicedText;
  final Color displayNameInputBackground;
  final Color displayNameInputBorder;
  final Color displayNameInputText;

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
    required this.warning,
    required this.warningSoft,
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
    required this.versionSelectedBackground,
    required this.versionSelectedBorder,
    required this.versionSubtitle,
    required this.shareText,
    required this.historyCardBackground,
    required this.historyCardBorder,
    required this.tagNewBackground,
    required this.tagNewText,
    required this.tagLevelA,
    required this.tagLevelB1,
    required this.tagLevelB2,
    required this.tagLevelC1,
    required this.tagLevelText,
    required this.tagCategoryBackground,
    required this.tagCategoryBorder,
    required this.videoDurationText,
    required this.hintButtonText,
    required this.scoreCardButtonBackground,
    required this.scoreCardButtonBorder,
    required this.xpCardBackground,
    required this.xpCardBorder,
    required this.streakCardBackground,
    required this.streakCardBorder,
    required this.badgeCardBackground,
    required this.badgeCardBorder,
    required this.accentCardBackground,
    required this.accentCardBorder,
    required this.streakCellActive,
    required this.streakCellInactive,
    required this.weeklyXpBarStart,
    required this.weeklyXpBarEnd,
    required this.levelProgressBar,
    required this.practicedText,
    required this.displayNameInputBackground,
    required this.displayNameInputBorder,
    required this.displayNameInputText,
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
    Color? warning,
    Color? warningSoft,
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
    Color? versionSelectedBackground,
    Color? versionSelectedBorder,
    Color? versionSubtitle,
    Color? shareText,
    Color? historyCardBackground,
    Color? historyCardBorder,
    Color? tagNewBackground,
    Color? tagNewText,
    Color? tagLevelA,
    Color? tagLevelB1,
    Color? tagLevelB2,
    Color? tagLevelC1,
    Color? tagLevelText,
    Color? tagCategoryBackground,
    Color? tagCategoryBorder,
    Color? videoDurationText,
    Color? hintButtonText,
    Color? scoreCardButtonBackground,
    Color? scoreCardButtonBorder,
    Color? xpCardBackground,
    Color? xpCardBorder,
    Color? streakCardBackground,
    Color? streakCardBorder,
    Color? badgeCardBackground,
    Color? badgeCardBorder,
    Color? accentCardBackground,
    Color? accentCardBorder,
    Color? streakCellActive,
    Color? streakCellInactive,
    Color? weeklyXpBarStart,
    Color? weeklyXpBarEnd,
    Color? levelProgressBar,
    Color? practicedText,
    Color? displayNameInputBackground,
    Color? displayNameInputBorder,
    Color? displayNameInputText,
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
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
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
      versionSelectedBackground:
          versionSelectedBackground ?? this.versionSelectedBackground,
      versionSelectedBorder:
          versionSelectedBorder ?? this.versionSelectedBorder,
      versionSubtitle: versionSubtitle ?? this.versionSubtitle,
      shareText: shareText ?? this.shareText,
      historyCardBackground:
          historyCardBackground ?? this.historyCardBackground,
      historyCardBorder: historyCardBorder ?? this.historyCardBorder,
      tagNewBackground: tagNewBackground ?? this.tagNewBackground,
      tagNewText: tagNewText ?? this.tagNewText,
      tagLevelA: tagLevelA ?? this.tagLevelA,
      tagLevelB1: tagLevelB1 ?? this.tagLevelB1,
      tagLevelB2: tagLevelB2 ?? this.tagLevelB2,
      tagLevelC1: tagLevelC1 ?? this.tagLevelC1,
      tagLevelText: tagLevelText ?? this.tagLevelText,
      tagCategoryBackground:
          tagCategoryBackground ?? this.tagCategoryBackground,
      tagCategoryBorder: tagCategoryBorder ?? this.tagCategoryBorder,
      videoDurationText: videoDurationText ?? this.videoDurationText,
      hintButtonText: hintButtonText ?? this.hintButtonText,
      scoreCardButtonBackground:
          scoreCardButtonBackground ?? this.scoreCardButtonBackground,
      scoreCardButtonBorder:
          scoreCardButtonBorder ?? this.scoreCardButtonBorder,
      xpCardBackground: xpCardBackground ?? this.xpCardBackground,
      xpCardBorder: xpCardBorder ?? this.xpCardBorder,
      streakCardBackground: streakCardBackground ?? this.streakCardBackground,
      streakCardBorder: streakCardBorder ?? this.streakCardBorder,
      badgeCardBackground: badgeCardBackground ?? this.badgeCardBackground,
      badgeCardBorder: badgeCardBorder ?? this.badgeCardBorder,
      accentCardBackground: accentCardBackground ?? this.accentCardBackground,
      accentCardBorder: accentCardBorder ?? this.accentCardBorder,
      streakCellActive: streakCellActive ?? this.streakCellActive,
      streakCellInactive: streakCellInactive ?? this.streakCellInactive,
      weeklyXpBarStart: weeklyXpBarStart ?? this.weeklyXpBarStart,
      weeklyXpBarEnd: weeklyXpBarEnd ?? this.weeklyXpBarEnd,
      levelProgressBar: levelProgressBar ?? this.levelProgressBar,
      practicedText: practicedText ?? this.practicedText,
      displayNameInputBackground:
          displayNameInputBackground ?? this.displayNameInputBackground,
      displayNameInputBorder:
          displayNameInputBorder ?? this.displayNameInputBorder,
      displayNameInputText: displayNameInputText ?? this.displayNameInputText,
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
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
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
      socialBackground: Color.lerp(
        socialBackground,
        other.socialBackground,
        t,
      )!,
      socialBorder: Color.lerp(socialBorder, other.socialBorder, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      logoPlay: Color.lerp(logoPlay, other.logoPlay, t)!,
      logoBackground: Color.lerp(logoBackground, other.logoBackground, t)!,
      logoBorder: Color.lerp(logoBorder, other.logoBorder, t)!,
      logoUnderline: Color.lerp(logoUnderline, other.logoUnderline, t)!,
      infoSoft: Color.lerp(infoSoft, other.infoSoft, t)!,
      versionSelectedBackground: Color.lerp(
        versionSelectedBackground,
        other.versionSelectedBackground,
        t,
      )!,
      versionSelectedBorder: Color.lerp(
        versionSelectedBorder,
        other.versionSelectedBorder,
        t,
      )!,
      versionSubtitle: Color.lerp(versionSubtitle, other.versionSubtitle, t)!,
      shareText: Color.lerp(shareText, other.shareText, t)!,
      historyCardBackground: Color.lerp(
        historyCardBackground,
        other.historyCardBackground,
        t,
      )!,
      historyCardBorder: Color.lerp(
        historyCardBorder,
        other.historyCardBorder,
        t,
      )!,
      tagNewBackground: Color.lerp(
        tagNewBackground,
        other.tagNewBackground,
        t,
      )!,
      tagNewText: Color.lerp(tagNewText, other.tagNewText, t)!,
      tagLevelA: Color.lerp(tagLevelA, other.tagLevelA, t)!,
      tagLevelB1: Color.lerp(tagLevelB1, other.tagLevelB1, t)!,
      tagLevelB2: Color.lerp(tagLevelB2, other.tagLevelB2, t)!,
      tagLevelC1: Color.lerp(tagLevelC1, other.tagLevelC1, t)!,
      tagLevelText: Color.lerp(tagLevelText, other.tagLevelText, t)!,
      tagCategoryBackground: Color.lerp(
        tagCategoryBackground,
        other.tagCategoryBackground,
        t,
      )!,
      tagCategoryBorder: Color.lerp(
        tagCategoryBorder,
        other.tagCategoryBorder,
        t,
      )!,
      videoDurationText: Color.lerp(
        videoDurationText,
        other.videoDurationText,
        t,
      )!,
      hintButtonText: Color.lerp(hintButtonText, other.hintButtonText, t)!,
      scoreCardButtonBackground: Color.lerp(
        scoreCardButtonBackground,
        other.scoreCardButtonBackground,
        t,
      )!,
      scoreCardButtonBorder: Color.lerp(
        scoreCardButtonBorder,
        other.scoreCardButtonBorder,
        t,
      )!,
      xpCardBackground: Color.lerp(
        xpCardBackground,
        other.xpCardBackground,
        t,
      )!,
      xpCardBorder: Color.lerp(xpCardBorder, other.xpCardBorder, t)!,
      streakCardBackground: Color.lerp(
        streakCardBackground,
        other.streakCardBackground,
        t,
      )!,
      streakCardBorder: Color.lerp(
        streakCardBorder,
        other.streakCardBorder,
        t,
      )!,
      badgeCardBackground: Color.lerp(
        badgeCardBackground,
        other.badgeCardBackground,
        t,
      )!,
      badgeCardBorder: Color.lerp(badgeCardBorder, other.badgeCardBorder, t)!,
      accentCardBackground: Color.lerp(
        accentCardBackground,
        other.accentCardBackground,
        t,
      )!,
      accentCardBorder: Color.lerp(
        accentCardBorder,
        other.accentCardBorder,
        t,
      )!,
      streakCellActive: Color.lerp(
        streakCellActive,
        other.streakCellActive,
        t,
      )!,
      streakCellInactive: Color.lerp(
        streakCellInactive,
        other.streakCellInactive,
        t,
      )!,
      weeklyXpBarStart: Color.lerp(
        weeklyXpBarStart,
        other.weeklyXpBarStart,
        t,
      )!,
      weeklyXpBarEnd: Color.lerp(
        weeklyXpBarEnd,
        other.weeklyXpBarEnd,
        t,
      )!,
      levelProgressBar: Color.lerp(
        levelProgressBar,
        other.levelProgressBar,
        t,
      )!,
      practicedText: Color.lerp(practicedText, other.practicedText, t)!,
      displayNameInputBackground: Color.lerp(
        displayNameInputBackground,
        other.displayNameInputBackground,
        t,
      )!,
      displayNameInputBorder: Color.lerp(
        displayNameInputBorder,
        other.displayNameInputBorder,
        t,
      )!,
      displayNameInputText: Color.lerp(
        displayNameInputText,
        other.displayNameInputText,
        t,
      )!,
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
    warning: Color(0xFFD97706),
    warningSoft: Color(0x1AD97706),
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
    versionSelectedBackground: Color(0xFFDCEAF2),
    versionSelectedBorder: Color(0xFFA2D2E0),
    versionSubtitle: Color(0xFF8585A1),
    shareText: Color(0xFF4B4B63),
    historyCardBackground: Color(0xFFDAEDEA),
    historyCardBorder: Color(0xFF9EDBC6),
    tagNewBackground: Color(0xFF16B877),
    tagNewText: Color(0xFF04140C),
    tagLevelA: Color(0xFF0FA899),
    tagLevelB1: Color(0xFF2B80FF),
    tagLevelB2: Color(0xFF9234EB),
    tagLevelC1: Color(0xFFEB5B34),
    tagLevelText: Color(0xFF0A0A12),
    tagCategoryBackground: Color(0xFFF5F5FA),
    tagCategoryBorder: Color(0xFFE6E6EB),
    videoDurationText: Color(0xFF6D6D87),
    hintButtonText: Color(0xFFF59F0A),
    scoreCardButtonBackground: Color(0xFFF0F0F5),
    scoreCardButtonBorder: Color(0xFFD7D7DE),
    xpCardBackground: Color(0xFFE6F8FA),
    xpCardBorder: Color(0xFFB2EBF2),
    streakCardBackground: Color(0xFFF5E9DC),
    streakCardBorder: Color(0xFFF2CB9B),
    badgeCardBackground: Color(0xFFF3E8FF),
    badgeCardBorder: Color(0xFFE9D5FF),
    accentCardBackground: Color(0xFFE0F7FA),
    accentCardBorder: Color(0xFFB2EBF2),
    streakCellActive: Color(0xFFF0890C),
    streakCellInactive: Color(0xFFEDEDF5),
    weeklyXpBarStart: Color(0xFF00C9B2),
    weeklyXpBarEnd: Color(0xFF5CF2E3),
    levelProgressBar: Color(0xFF2FEBD8),
    practicedText: Color(0xFF6D6D87),
    displayNameInputBackground: Color(0xFFEDEDF5),
    displayNameInputBorder: Color(0xFFD2D2D9),
    displayNameInputText: Color(0xFF757575),
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
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0x29F59E0B),
    success: Color(0xFF22D98C),
    successBackground: Color(0xFF153331),
    successBorder: Color(0xFF22D98C),
    optionCardBackground: Color(0xFF1E2238),
    optionCardBorder: Color(0xFF2A2F48),
    inputBackground: Color(0xFF13131F),
    inputBorder: Color(0xFF2F2F38),
    socialBackground: Color(0xFF20203B),
    socialBorder: Color(0xFF3B3B52),
    hintText: Color(0xFF757575),
    logoPlay: Color(0xFF00E6CB),
    logoBackground: Color(0xFF0D0D1A),
    logoBorder: Color(0xFF094D4F),
    logoUnderline: Color(0xFFA854F7),
    infoSoft: Color(0xFF22304F),
    versionSelectedBackground: Color(0xFF0B2B33),
    versionSelectedBorder: Color(0xFF086362),
    versionSubtitle: Color(0xFF8585A1),
    shareText: Color(0xFFA6A6BF),
    historyCardBackground: Color(0xFF102E2D),
    historyCardBorder: Color(0xFF156149),
    tagNewBackground: Color(0xFF23D98D),
    tagNewText: Color(0xFF04140C),
    tagLevelA: Color(0xFF3ED6C4),
    tagLevelB1: Color(0xFF4DA0FF),
    tagLevelB2: Color(0xFFA854F7),
    tagLevelC1: Color(0xFFFF7A59),
    tagLevelText: Color(0xFF0A0A12),
    tagCategoryBackground: Color(0xFF20203B),
    tagCategoryBorder: Color(0xFF2E2E45),
    videoDurationText: Color(0xFF83839E),
    hintButtonText: Color(0xFFFFB13D),
    scoreCardButtonBackground: Color(0xFF1D1D36),
    scoreCardButtonBorder: Color(0xFF38384F),
    xpCardBackground: Color(0xFF163645),
    xpCardBorder: Color(0xFF15535E),
    streakCardBackground: Color(0xFF332720),
    streakCardBorder: Color(0xFF735229),
    badgeCardBackground: Color(0xFF1B1B33),
    badgeCardBorder: Color(0xFF33335A),
    accentCardBackground: Color(0xFF163645),
    accentCardBorder: Color(0xFF155E68),
    streakCellActive: Color(0xFFFFB13D),
    streakCellInactive: Color(0xFF13131F),
    weeklyXpBarStart: Color(0xFF00C9B2),
    weeklyXpBarEnd: Color(0xFF5CF2E3),
    levelProgressBar: Color(0xFF37EDD8),
    practicedText: Color(0xFF8585A1),
    displayNameInputBackground: Color(0xFF13131F),
    displayNameInputBorder: Color(0xFF31313B),
    displayNameInputText: Color(0xFF6A6A6B),
  );
}

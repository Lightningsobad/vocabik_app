import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'vocabik_logo.dart';
import 'vocabik_brand_text.dart';
import 'header_pill_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'stat_badge.dart';
import 'header_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/gamification/cubit/gamification_global_cubit.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onThemeTap;
  final VoidCallback? onMenuTap;

  const AppHeader({
    super.key,
    this.onHomeTap,
    this.onThemeTap,
    this.onMenuTap,
  });

  static final _numberFormat = NumberFormat.decimalPattern();

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.headerHeight);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final currentLang = context.select((LocalizationCubit cubit) => cubit.state.currentLocale.languageCode);
    final displayLanguage = currentLang == 'en' ? 'EN' : 'VI';
    
    final streak = context.select((GamificationGlobalCubit cubit) => cubit.state.streak);
    final xp = context.select((GamificationGlobalCubit cubit) => cubit.state.xp);
    final isLoading = context.select((GamificationGlobalCubit cubit) => cubit.state.isLoading);
    
    final topPadding = MediaQuery.paddingOf(context).top;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.1,
        ),
      ),
      child: Container(
        height: AppSpacing.headerHeight + topPadding,
        padding: EdgeInsets.only(
          top: topPadding,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceCard, // Flat design with solid surfaceCard background
          border: Border(
            bottom: BorderSide(
              color: colors.borderSubtle,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Section: Logo & Name
            BounceWrapper(
              onTap: onHomeTap,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VocabikLogo(),
                  SizedBox(width: AppSpacing.sm),
                  VocabikBrandText(),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Right Section: Stats & Actions
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isLoading)
                      AppShimmer(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.tnn),
                            Container(
                              width: 38,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      StatBadge(
                        iconAsset: 'assets/home_screen/streak_icon.svg',
                        valueText: streak.toString(),
                        color: AppColors.streak, // streak color
                      ),
                      const SizedBox(width: AppSpacing.sm2),
                      StatBadge(
                        iconAsset: 'assets/home_screen/xp_icon.svg',
                        valueText: _numberFormat.format(xp),
                        color: colors.primaryAccent, // xp color
                      ),
                    ],
                    const SizedBox(width: AppSpacing.sm2),
                    HeaderPillButton(
                      text: displayLanguage,
                      onTap: () {
                        final newLang = currentLang == 'vi' ? 'en' : 'vi';
                        context.read<LocalizationCubit>().changeLanguage(newLang);
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm2),
                    HeaderCircleButton(
                      icon: SvgPicture.asset(
                        isDarkMode ? 'assets/home_screen/moon_icon.svg' : 'assets/home_screen/sun.svg',
                        width: 16,
                        height: 16,
                      ),
                      onTap: onThemeTap ?? () => context.read<ThemeCubit>().toggleTheme(),
                    ),
                    const SizedBox(width: AppSpacing.sm2),
                    HeaderCircleButton(
                      icon: Icon(
                        LucideIcons.layoutGrid,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                      onTap: onMenuTap ?? () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

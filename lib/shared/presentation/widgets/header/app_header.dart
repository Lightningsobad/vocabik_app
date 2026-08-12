import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'vocabik_logo.dart';
import 'vocabik_brand_text.dart';
import 'stat_badge.dart';
import 'header_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
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
    
    final topPadding = MediaQuery.paddingOf(context).top;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.1,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // blur-md
        child: Container(
          height: AppSpacing.headerHeight + topPadding,
          padding: EdgeInsets.only(
            top: topPadding,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
            decoration: BoxDecoration(
              color: colors.glassFill, // glass-fill
              border: Border(
                bottom: BorderSide(
                  color: colors.borderSubtle, // border-subtle
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
                    children: [
                      VocabikLogo(),
                      SizedBox(width: AppSpacing.sm),
                      VocabikBrandText(),
                    ],
                  ),
                ),

                // Right Section: Stats & Actions
                Wrap(
                  spacing: AppSpacing.md,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatBadge(
                      emoji: '🔥',
                      valueText: streak.toString(),
                      color: AppColors.streak, // streak color
                    ),
                    StatBadge(
                      emoji: '⚡',
                      valueText: _numberFormat.format(xp),
                      color: AppColors.accent, // xp color
                    ),
                    HeaderCircleButton(
                      text: displayLanguage,
                      onTap: () {
                        final newLang = currentLang == 'vi' ? 'en' : 'vi';
                        context.read<LocalizationCubit>().changeLanguage(newLang);
                      },
                    ),
                    HeaderCircleButton(
                      text: isDarkMode ? '🌙' : '☀️',
                      onTap: onThemeTap ?? () => context.read<ThemeCubit>().toggleTheme(),
                    ),
                    HeaderCircleButton(
                      icon: Icon(
                        LucideIcons.layoutGrid,
                        size: 16,
                        color: colors.textSecondary, // text-secondary
                      ),
                      onTap: onMenuTap ?? () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

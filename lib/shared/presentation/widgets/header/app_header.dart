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

class AppHeader extends StatelessWidget {
  final int streak;
  final int xp;
  final String currentLanguageCode;
  final VoidCallback? onHomeTap;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onThemeTap;
  final VoidCallback? onMenuTap;

  const AppHeader({
    super.key,
    required this.streak,
    required this.xp,
    required this.currentLanguageCode,
    this.onHomeTap,
    this.onLanguageTap,
    this.onThemeTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng NumberFormat để định dạng số, ví dụ 1,240
    final format = NumberFormat.decimalPattern();
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // blur-md
          child: Container(
            height: AppSpacing.headerHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                GestureDetector(
                  onTap: onHomeTap,
                  behavior: HitTestBehavior.opaque,
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
                      valueText: format.format(xp),
                      color: AppColors.accent, // xp color
                    ),
                    HeaderCircleButton(
                      text: currentLanguageCode.toUpperCase(),
                      onTap: onLanguageTap ?? () {},
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

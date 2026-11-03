import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../shared/presentation/widgets/app_progress_bar.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/badge_entity.dart';

class BadgeCard extends StatelessWidget {
  final BadgeEntity badge;

  const BadgeCard({super.key, required this.badge});

  static const List<double> _grayscaleMatrix = <double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  String _getIconAsset(String code, String? iconRef) {
    switch (code) {
      case 'first_b2':
        return 'assets/archievements_screen/first_B2_icon.png';
      case 'seven_day_streak':
        return 'assets/archievements_screen/streak_icon.svg';
      case 'vocabulary_hunter':
        return 'assets/archievements_screen/vocab_icon.svg';
      case 'genre_master':
        return 'assets/archievements_screen/music_icon.png';
      case 'speed_demon':
        return 'assets/archievements_screen/xp_icon.svg';
      case 'first_exercise':
        return 'assets/archievements_screen/accuracy_icon.svg';
      case 'contributor':
        return 'assets/archievements_screen/centurion_icon.svg';
    }

    if (iconRef != null) {
      final lower = iconRef.toLowerCase();
      if (lower.contains('first_b2')) {
        return 'assets/archievements_screen/first_B2_icon.png';
      } else if (lower.contains('streak')) {
        return 'assets/archievements_screen/streak_icon.svg';
      } else if (lower.contains('vocab')) {
        return 'assets/archievements_screen/vocab_icon.svg';
      } else if (lower.contains('music') || lower.contains('genre')) {
        return 'assets/archievements_screen/music_icon.png';
      } else if (lower.contains('xp') || lower.contains('speed')) {
        return 'assets/archievements_screen/xp_icon.svg';
      } else if (lower.contains('accuracy') || lower.contains('exercise')) {
        return 'assets/archievements_screen/accuracy_icon.svg';
      } else if (lower.contains('centurion') || lower.contains('contributor')) {
        return 'assets/archievements_screen/centurion_icon.svg';
      }
    }

    return 'assets/archievements_screen/trophy.svg';
  }

  Widget _buildIcon(String assetPath, bool isLocked) {
    final Widget iconWidget = assetPath.endsWith('.svg')
        ? SvgPicture.asset(assetPath, width: 44, height: 44)
        : Image.asset(assetPath, width: 44, height: 44, fit: BoxFit.contain);

    if (isLocked) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(_grayscaleMatrix),
        child: Opacity(opacity: 0.45, child: iconWidget),
      );
    }

    return iconWidget;
  }

  Widget _buildProgressBar(
    BuildContext context,
    AppColorsExtension colors,
    BadgeProgressEntity progress,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppProgressBar(
          progress: progress.percentage,
          height: AppSpacing.sm,
          color: colors.primaryAccent,
          backgroundColor: colors.background,
          animate: true,
        ),
        const SizedBox(height: AppSpacing.tn),
        Text(
          '${progress.current} / ${progress.target}',
          style: AppTextStyles.custom(
            fontSize: AppFontSize.tn2,
            fontWeight: FontWeight.w700,
            color: badge.locked ? colors.textSecondary : colors.primaryAccent,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final assetPath = _getIconAsset(badge.code, badge.iconRef);
    final isLocked = badge.locked;
    final progress = badge.progress;

    String? formattedDate;
    if (badge.awardedAt != null) {
      formattedDate = DateFormat('dd/MM/yyyy').format(badge.awardedAt!);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md2,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg2),
        border: Border.all(
          color: isLocked
              ? colors.borderSubtle
              : colors.primaryAccent.withValues(alpha: 0.4),
          width: 1.0,
        ),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: colors.primaryAccent.withValues(alpha: 0.35),
                  blurRadius: 16.0,
                  spreadRadius: 0.0,
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(assetPath, isLocked),
          const SizedBox(height: AppSpacing.lg),
          Text(
            badge.displayName,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg,
              fontWeight: FontWeight.w900,
              color: isLocked ? colors.textSecondary : colors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.tn),
          if (!isLocked && formattedDate != null) ...[
            Text(
              formattedDate,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (isLocked && progress != null) ...[
            _buildProgressBar(context, colors, progress),
          ] else if (isLocked && badge.description.isNotEmpty) ...[
            Text(
              badge.description,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class XpLeaderboardHeader extends StatelessWidget {
  final String? nextResetAt;

  const XpLeaderboardHeader({super.key, this.nextResetAt});

  String _formatResetTime(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (nextResetAt == null || nextResetAt!.isEmpty) return '';

    try {
      final resetDate = DateTime.parse(nextResetAt!).toLocal();
      final now = DateTime.now();
      final difference = resetDate.difference(now);

      if (difference.isNegative) {
        return l10n?.xpLeaderboardResettingSoon ?? 'Resetting soon';
      }

      if (difference.inDays >= 1) {
        final days = difference.inDays;
        return l10n?.xpLeaderboardResetsInDays(days) ?? 'Resets in: $days days';
      } else if (difference.inHours >= 1) {
        final hours = difference.inHours;
        return l10n?.xpLeaderboardResetsInHours(hours) ?? 'Resets in: $hours hours';
      } else {
        final minutes = difference.inMinutes;
        return l10n?.xpLeaderboardResetsInMinutes(minutes) ?? 'Resets in: $minutes min';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);
    final resetText = _formatResetTime(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            l10n?.xpLeaderboardTitle ?? 'XP Leaderboard',
            style: AppTextStyles.custom(
              color: colors.textPrimary,
              fontSize: AppFontSize.xl5,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (resetText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                resetText,
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

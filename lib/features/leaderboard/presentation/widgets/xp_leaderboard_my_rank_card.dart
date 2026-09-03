import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/core/utils/number_format_utils.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

class XpLeaderboardMyRankCard extends StatelessWidget {
  final LeaderboardEntryEntity? ownRank;
  final int? totalParticipants;

  const XpLeaderboardMyRankCard({
    super.key,
    required this.ownRank,
    this.totalParticipants,
  });

  @override
  Widget build(BuildContext context) {
    if (ownRank == null && (totalParticipants == null || totalParticipants == 0)) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);

    final rankDisplay = ownRank != null ? '#${ownRank!.rank}' : '#--';
    final xpDisplay = ownRank != null
        ? '${ownRank!.xp.toFormattedCommas()} XP'
        : '0 XP';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md2,
        ),
        decoration: BoxDecoration(
          color: colors.primaryAccent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: colors.primaryAccent.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // 1. Label "Your rank"
            Text(
              l10n?.xpLeaderboardYourRank ?? 'Your rank',
              style: AppTextStyles.custom(
                color: colors.textSecondary,
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // 2. Rank Number
            Text(
              rankDisplay,
              style: AppTextStyles.custom(
                color: colors.primaryAccent,
                fontSize: AppFontSize.xl4,
                fontWeight: FontWeight.w900,
              ),
            ),

            // 3. Total Participants (e.g. / 1,234)
            if (totalParticipants != null && totalParticipants! > 0) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '/ ${totalParticipants!.toFormattedCommas()}',
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const Spacer(),

            // 4. XP with Lightning Icon
            SvgPicture.asset(
              'assets/home_screen/xp_icon.svg',
              width: 18,
              height: 18,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              xpDisplay,
              style: AppTextStyles.custom(
                color: colors.primaryAccent,
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

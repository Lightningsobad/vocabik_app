import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/leaderboard/shared_leaderboard_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/daily_challenge_leaderboard_entity.dart';
import 'daily_challenge_leaderboard_tile.dart';

class DailyChallengeLeaderboard extends StatelessWidget {
  final List<DailyChallengeLeaderboardItemEntity> leaderboard;
  final bool isLoading;

  const DailyChallengeLeaderboard({
    super.key,
    required this.leaderboard,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyChallengeTopToday,
            style: AppTextStyles.custom(
              color: colors.textPrimary,
              fontSize: AppFontSize.lg2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md2),
          if (isLoading)
            const SharedLeaderboardShimmer(itemCount: 4)
          else if (leaderboard.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.dailyChallengeNoParticipants,
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                return DailyChallengeLeaderboardTile(item: leaderboard[index]);
              },
            ),
        ],
      ),
    );
  }
}

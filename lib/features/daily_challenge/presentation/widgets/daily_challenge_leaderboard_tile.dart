import 'package:flutter/material.dart';
import 'package:vocabik_app/core/utils/number_format_utils.dart';
import 'package:vocabik_app/shared/presentation/widgets/leaderboard/shared_leaderboard_tile.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/daily_challenge_leaderboard_entity.dart';

class DailyChallengeLeaderboardTile extends StatelessWidget {
  final DailyChallengeLeaderboardItemEntity item;

  const DailyChallengeLeaderboardTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final formattedTime = item.scoreTimeMs.toFormattedTime();
    final formattedScore = '${item.scoreAccuracy}%';

    return SharedLeaderboardTile(
      rank: item.rank,
      userName: item.userName,
      avatarUrl: item.avatarUrl,
      isCurrentUser: item.isCurrentUser,
      goldMedalAsset: 'assets/daily_challenge_screen/gold_medal_icon.svg',
      silverMedalAsset: 'assets/daily_challenge_screen/silver_medal_icon.svg',
      bronzeMedalAsset: 'assets/daily_challenge_screen/bronze_medal_icon.svg',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formattedTime,
            style: AppTextStyles.custom(
              color: colors.textSecondary,
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            formattedScore,
            style: AppTextStyles.custom(
              color: colors.tagNewBackground,
              fontSize: AppFontSize.xl,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

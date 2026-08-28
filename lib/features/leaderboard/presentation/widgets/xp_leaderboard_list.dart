import 'package:flutter/material.dart';
import 'package:vocabik_app/core/utils/number_format_utils.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/leaderboard/shared_leaderboard_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/leaderboard/shared_leaderboard_tile.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

class XpLeaderboardList extends StatelessWidget {
  final List<LeaderboardEntryEntity> entries;
  final List<LeaderboardEntryEntity>? surrounding;
  final bool isLoading;

  const XpLeaderboardList({
    super.key,
    required this.entries,
    this.surrounding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: SharedLeaderboardShimmer(itemCount: 8),
      );
    }

    if (entries.isEmpty && (surrounding == null || surrounding!.isEmpty)) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl2,
        ),
        alignment: Alignment.center,
        child: Text(
          l10n?.xpLeaderboardEmpty ?? 'No leaderboard data found',
          style: AppTextStyles.custom(
            color: colors.textSecondary,
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Entries List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildTile(context, colors, entry);
            },
          ),

          // 2. Surrounding items separator and list
          if (surrounding != null && surrounding!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm2),
              child: Center(
                child: Text(
                  '• • •',
                  style: AppTextStyles.custom(
                    color: colors.textSecondary,
                    fontSize: AppFontSize.lg,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: surrounding!.length,
              itemBuilder: (context, index) {
                final entry = surrounding![index];
                return _buildTile(context, colors, entry);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    AppColorsExtension colors,
    LeaderboardEntryEntity entry,
  ) {
    return SharedLeaderboardTile(
      rank: entry.rank,
      userName: entry.isCurrentUser ? 'You' : entry.displayName,
      avatarUrl: entry.avatarUrl,
      isCurrentUser: entry.isCurrentUser,
      goldMedalAsset: 'assets/xp_leaderboard_screen/gold_medal_icon.svg',
      silverMedalAsset: 'assets/xp_leaderboard_screen/silver_medal_icon.svg',
      bronzeMedalAsset: 'assets/xp_leaderboard_screen/bronze_medal_icon.svg',
      trailing: Text(
        '${entry.xp.toFormattedCommas()} XP',
        style: AppTextStyles.custom(
          color: colors.tagNewBackground,
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

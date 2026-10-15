import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/core/utils/string_extensions.dart';
import 'package:vocabik_app/features/moderation/presentation/widgets/user_action_bottom_sheet.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class SharedLeaderboardTile extends StatelessWidget {
  final int rank;
  final String? userId;
  final String userName;
  final String? avatarUrl;
  final bool isCurrentUser;
  final Widget trailing;
  final String? goldMedalAsset;
  final String? silverMedalAsset;
  final String? bronzeMedalAsset;
  final VoidCallback? onUserBlocked;

  const SharedLeaderboardTile({
    super.key,
    required this.rank,
    this.userId,
    required this.userName,
    this.avatarUrl,
    this.isCurrentUser = false,
    required this.trailing,
    this.goldMedalAsset,
    this.silverMedalAsset,
    this.bronzeMedalAsset,
    this.onUserBlocked,
  });

  Widget _buildRankWidget(BuildContext context, AppColorsExtension colors) {
    final gold = goldMedalAsset ?? 'assets/xp_leaderboard_screen/gold_medal_icon.svg';
    final silver = silverMedalAsset ?? 'assets/xp_leaderboard_screen/silver_medal_icon.svg';
    final bronze = bronzeMedalAsset ?? 'assets/xp_leaderboard_screen/bronze_medal_icon.svg';

    if (rank == 1) {
      return SvgPicture.asset(
        gold,
        width: 22,
        height: 22,
      );
    } else if (rank == 2) {
      return SvgPicture.asset(
        silver,
        width: 22,
        height: 22,
      );
    } else if (rank == 3) {
      return SvgPicture.asset(
        bronze,
        width: 22,
        height: 22,
      );
    }

    return Text(
      '#$rank',
      style: AppTextStyles.custom(
        color: colors.textPrimary,
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final initials = userName.toInitials();
    final tileBgColor = isCurrentUser
        ? colors.primaryAccent.withValues(alpha: 0.10)
        : colors.surfaceCard;
    final tileBorderColor = isCurrentUser
        ? colors.primaryAccent.withValues(alpha: 0.5)
        : colors.borderSubtle;

    final tileWidget = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm2,
      ),
      decoration: BoxDecoration(
        color: tileBgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tileBorderColor),
      ),
      child: Row(
        children: [
          // 1. Rank
          SizedBox(
            width: 32,
            child: Center(child: _buildRankWidget(context, colors)),
          ),
          const SizedBox(width: AppSpacing.lg2),

          // 2. Avatar / Initials
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.tabUnselectedBackground,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    cacheWidth: 100,
                    cacheHeight: 100,
                    errorBuilder: (context, error, stackTrace) => Text(
                      initials,
                      style: AppTextStyles.custom(
                        color: colors.textSecondary,
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : Text(
                    initials,
                    style: AppTextStyles.custom(
                      color: isCurrentUser
                          ? colors.primaryAccent
                          : colors.textSecondary,
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),

          // 3. User Name & YOU Badge
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    userName,
                    style: AppTextStyles.custom(
                      color: isCurrentUser ? colors.primaryAccent : colors.textPrimary,
                      fontSize: AppFontSize.lg2,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      'YOU',
                      style: AppTextStyles.custom(
                        color: colors.primaryAccent,
                        fontSize: AppFontSize.tnn,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // 4. Trailing widget (score, xp, time, etc.)
          trailing,
        ],
      ),
    );

    if (isCurrentUser) {
      return tileWidget;
    }

    return InkWell(
      onTap: () {
        final id = userId ?? userName;
        UserActionBottomSheet.show(
          context,
          userId: id,
          userName: userName,
          onUserBlocked: onUserBlocked,
        );
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: tileWidget,
    );
  }
}

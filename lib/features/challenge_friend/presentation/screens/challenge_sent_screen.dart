import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/friend_entity.dart';
import '../models/challenge_sent_args.dart';

class ChallengeSentScreen extends StatelessWidget {
  final ChallengeSentArgs args;

  const ChallengeSentScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final subtitleText = args.selectedFriends.length == 1
        ? l10n.challengeSentSubtitleSingle(
            args.accuracyScore,
            args.videoTitle,
            args.selectedFriends.first.displayName,
          )
        : l10n.challengeSentSubtitleMultiple(
            args.accuracyScore,
            args.videoTitle,
            args.selectedFriends.length,
          );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),

          // Glowing Swords Icon
          _buildGlowIcon(colors),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            l10n.challengeSentTitle,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.xl5,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              subtitleText,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Challenged Friends Chips
          _buildFriendChips(colors),
          const SizedBox(height: AppSpacing.xl),

          // Info Card
          _buildInfoCard(colors, l10n),
          const SizedBox(height: AppSpacing.xl),

          // Action Buttons
          _buildActionButtons(context, colors, l10n),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildGlowIcon(AppColorsExtension colors) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF10282C),
        border: Border.all(
          color: colors.primaryAccent.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primaryAccent.withValues(alpha: 0.35),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/result_screen/challenge_icon.svg',
          width: 44,
          height: 44,
        ),
      ),
    );
  }

  Widget _buildFriendChips(AppColorsExtension colors) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm2,
      runSpacing: AppSpacing.sm2,
      children: args.selectedFriends.map((friend) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSubtle, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSmallAvatar(friend, colors),
              const SizedBox(width: AppSpacing.xs),
              Text(
                friend.displayName,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmallAvatar(FriendEntity friend, AppColorsExtension colors) {
    const size = 26.0;
    if (friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          friend.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildSmallInitialsAvatar(friend, colors, size),
        ),
      );
    }
    return _buildSmallInitialsAvatar(friend, colors, size);
  }

  Widget _buildSmallInitialsAvatar(
    FriendEntity friend,
    AppColorsExtension colors,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF22253B),
        shape: BoxShape.circle,
      ),
      child: Text(
        friend.initials,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.tn,
          fontWeight: FontWeight.w800,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(AppColorsExtension colors, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icon(
              Icons.timer_outlined,
              color: colors.textSecondary,
              size: 24,
            ),
            title: l10n.challengeInfo24HoursTitle,
            desc: l10n.challengeInfo24HoursDesc,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.md2),
          _buildInfoRow(
            icon: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFFFB800),
              size: 24,
            ),
            title: l10n.challengeInfoNotifiedTitle,
            desc: l10n.challengeInfoNotifiedDesc,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.md2),
          _buildInfoRow(
            icon: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFFFF9500),
              size: 24,
            ),
            title: l10n.challengeInfoWinXpTitle,
            desc: l10n.challengeInfoWinXpDesc,
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required Widget icon,
    required String title,
    required String desc,
    required AppColorsExtension colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: icon),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        // Copy Challenge Link
        _buildActionButton(
          label: l10n.challengeCopyLink,
          leadingIcon: Icon(
            LucideIcons.link,
            size: 20,
            color: colors.textPrimary,
          ),
          colors: colors,
          onTap: () {
            Clipboard.setData(ClipboardData(text: args.challengeLink.url));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.challengeLinkCopied,
                  style: AppTextStyles.custom(
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSize.md,
                  ),
                ),
                backgroundColor: colors.surfaceCard,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm2),

        // View Leaderboard
        _buildActionButton(
          label: l10n.challengeViewLeaderboard,
          colors: colors,
          onTap: () {
            context.go('/progress/leaderboard');
          },
        ),
        const SizedBox(height: AppSpacing.sm2),

        // Back to Library
        _buildActionButton(
          label: l10n.resultBackToLibrary,
          colors: colors,
          onTap: () {
            context.go('/home');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required AppColorsExtension colors,
    required VoidCallback onTap,
    Widget? leadingIcon,
  }) {
    return BounceWrapper(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: colors.borderSubtle, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon,
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/friend_entity.dart';
import '../models/challenge_sent_args.dart';

class ChallengeSentScreen extends StatefulWidget {
  final ChallengeSentArgs args;

  const ChallengeSentScreen({super.key, required this.args});

  @override
  State<ChallengeSentScreen> createState() => _ChallengeSentScreenState();
}

class _ChallengeSentScreenState extends State<ChallengeSentScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _cardOffset;
  late final Animation<double> _cardOpacity;
  late final Animation<double> _buttonsOffset;
  late final Animation<double> _buttonsOpacity;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 1. Glowing Icon Pop-up: Starts at 200ms (0.17) -> finishes at 700ms (0.58)
    _iconScale = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.17, 0.58, curve: Curves.easeOutBack),
      ),
    );

    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.17, 0.42, curve: Curves.easeIn),
      ),
    );

    // 2. Info Card Float-up: Starts at 450ms (0.38) -> finishes at 850ms (0.71)
    _cardOffset = Tween<double>(begin: 35.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.38, 0.71, curve: Curves.easeOutCubic),
      ),
    );

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.38, 0.71, curve: Curves.easeIn),
      ),
    );

    // 3. Action Buttons Fade & Slide: Starts at 700ms (0.58) -> finishes at 1000ms (0.83)
    _buttonsOffset = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.58, 0.83, curve: Curves.easeOutCubic),
      ),
    );

    _buttonsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.58, 0.83, curve: Curves.easeIn),
      ),
    );

    _entranceController.forward().then((_) {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final subtitleText = widget.args.selectedFriends.length == 1
        ? l10n.challengeSentSubtitleSingle(
            widget.args.accuracyScore,
            widget.args.videoTitle,
            widget.args.selectedFriends.first.displayName,
          )
        : l10n.challengeSentSubtitleMultiple(
            widget.args.accuracyScore,
            widget.args.videoTitle,
            widget.args.selectedFriends.length,
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
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _pulseController]),
      builder: (context, child) {
        final pulseValue = _pulseController.value;
        final glowSpread = 4.0 + 4.0 * pulseValue;
        final glowBlur = 28.0 + 14.0 * pulseValue;

        return Transform.scale(
          scale: _iconScale.value,
          child: Opacity(
            opacity: _iconOpacity.value.clamp(0.0, 1.0),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10282C),
                border: Border.all(
                  color: colors.tagNewBackground
                      .withValues(alpha: 0.6 + 0.3 * pulseValue),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.tagNewBackground
                        .withValues(alpha: 0.4 + 0.3 * pulseValue),
                    blurRadius: glowBlur,
                    spreadRadius: glowSpread,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendChips(AppColorsExtension colors) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm2,
      runSpacing: AppSpacing.sm2,
      children: widget.args.selectedFriends.map((friend) {
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
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _cardOffset.value),
          child: Opacity(
            opacity: _cardOpacity.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderSubtle, width: 1),
        ),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Image.asset(
                'assets/home_screen/timer_icon.png',
                width: 24,
                height: 24,
              ),
              title: l10n.challengeInfo24HoursTitle,
              desc: l10n.challengeInfo24HoursDesc,
              colors: colors,
            ),
            const SizedBox(height: AppSpacing.md2),
            _buildInfoRow(
              icon: SvgPicture.asset(
                'assets/home_screen/notification_icon.svg',
                width: 24,
                height: 24,
              ),
              title: l10n.challengeInfoNotifiedTitle,
              desc: l10n.challengeInfoNotifiedDesc,
              colors: colors,
            ),
            const SizedBox(height: AppSpacing.md2),
            _buildInfoRow(
              icon: SvgPicture.asset(
                'assets/home_screen/xp_icon.svg',
                width: 24,
                height: 24,
              ),
              title: l10n.challengeInfoWinXpTitle,
              desc: l10n.challengeInfoWinXpDesc,
              colors: colors,
            ),
          ],
        ),
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
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _buttonsOffset.value),
          child: Opacity(
            opacity: _buttonsOpacity.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          // Copy Challenge Link
          _buildActionButton(
            label: l10n.challengeCopyLink,
            leadingIcon: SvgPicture.asset(
              'assets/result_screen/copy_icon.svg',
              width: 20,
              height: 20,
            ),
            colors: colors,
            onTap: () {
              Clipboard.setData(
                  ClipboardData(text: widget.args.challengeLink.url));
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
      ),
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

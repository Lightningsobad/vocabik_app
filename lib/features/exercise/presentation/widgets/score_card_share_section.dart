import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/services/share_service.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ScoreCardShareSection extends StatefulWidget {
  final ScoreCardStatus status;
  final String? imageUrl;
  final String videoId;
  final String videoTitle;
  final int accuracyScore;
  final VoidCallback onRetry;
  final VoidCallback? onChallengeFriend;

  const ScoreCardShareSection({
    super.key,
    required this.status,
    required this.imageUrl,
    required this.videoId,
    this.videoTitle = '',
    this.accuracyScore = 0,
    required this.onRetry,
    this.onChallengeFriend,
  });

  @override
  State<ScoreCardShareSection> createState() => _ScoreCardShareSectionState();
}

class _ScoreCardShareSectionState extends State<ScoreCardShareSection> {
  bool _isSharing = false;

  Future<void> _onShareImage(BuildContext context, AppLocalizations l10n) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final shareUrl = getIt<ShareService>().getLessonUrl(widget.videoId);
      final message = l10n.shareScoreCardMessage(
        widget.accuracyScore,
        widget.videoTitle,
        shareUrl,
      );

      final box = context.findRenderObject() as RenderBox?;
      final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      final didShareImage = await getIt<ShareService>().shareScoreCardImage(
        imageUrl: widget.imageUrl,
        videoId: widget.videoId,
        message: message,
        sharePositionOrigin: origin,
      );

      if (!didShareImage && widget.imageUrl != null && mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.resultShareImageFailedFallback,
              style: AppTextStyles.custom(
                fontWeight: FontWeight.w600,
                fontSize: AppFontSize.md,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      // shortcut: silent catch on user dismiss share sheet or platform error
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  Future<void> _onCopyLessonLink(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await getIt<ShareService>().copyLessonLink(widget.videoId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.resultCopiedToClipboard,
          style: AppTextStyles.custom(
            fontWeight: FontWeight.w600,
            fontSize: AppFontSize.md,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.resultShare,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.lg2,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Score Card Image Display with Aspect Ratio 1.91:1
        AspectRatio(
          aspectRatio: 1.91,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.borderSubtle, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildCardContent(context, colors, l10n),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Action Buttons Row: Instagram & Copy
        Row(
          children: [
            // Instagram Button
            Expanded(
              child: _buildActionButton(
                colors: colors,
                icon: SvgPicture.asset(
                  'assets/result_screen/share_ig_icon.svg',
                  width: 20,
                  height: 20,
                ),
                label: l10n.resultInstagram,
                isLoading: _isSharing,
                onTap: () => _onShareImage(context, l10n),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Copy Button
            Expanded(
              child: _buildActionButton(
                colors: colors,
                icon: SvgPicture.asset(
                  'assets/result_screen/copy_icon.svg',
                  width: 20,
                  height: 20,
                ),
                label: l10n.resultCopy,
                onTap: () => _onCopyLessonLink(context, l10n),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Challenge a Friend Button
        _buildActionButton(
          colors: colors,
          icon: SvgPicture.asset(
            'assets/result_screen/challenge_icon.svg',
            width: 20,
            height: 20,
          ),
          label: l10n.resultChallengeFriend,
          onTap: () {
            if (widget.onChallengeFriend != null) {
              widget.onChallengeFriend!();
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    if (widget.status == ScoreCardStatus.loading ||
        widget.status == ScoreCardStatus.initial) {
      return AppShimmer(child: Container(color: colors.surfaceCard));
    } else if (widget.status == ScoreCardStatus.offline) {
      return Container(
        color: colors.surfaceCard,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 36, color: colors.textSecondary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.resultNoInternetScoreCard,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.tn),
            TextButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                l10n.homeRetry,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryAccent,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.status == ScoreCardStatus.error) {
      return Container(
        color: colors.surfaceCard,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 36, color: colors.danger),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.resultScoreCardError,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.tn),
            TextButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                l10n.homeRetry,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryAccent,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return AppShimmer(child: Container(color: colors.surfaceCard));
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: colors.surfaceCard,
            child: Center(
              child: Text(
                l10n.resultScoreCardError,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(color: colors.surfaceCard);
  }

  Widget _buildActionButton({
    required Widget icon,
    required String label,
    required AppColorsExtension colors,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return PrimaryButton(
      leadingIcon: icon,
      text: label,
      isLoading: isLoading,
      variant: PrimaryButtonVariant.secondary,
      backgroundColor: colors.scoreCardButtonBackground,
      border: Border.all(color: colors.scoreCardButtonBorder, width: 1.5),
      textColor: colors.textPrimary,
      textStyle: AppTextStyles.custom(
        fontSize: AppFontSize.mdt,
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md2,
        horizontal: AppSpacing.md,
      ),
      onPressed: onTap,
    );
  }
}

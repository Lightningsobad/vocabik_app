import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ScoreCardShareSection extends StatelessWidget {
  final ScoreCardStatus status;
  final String? imageUrl;
  final VoidCallback onRetry;

  const ScoreCardShareSection({
    super.key,
    required this.status,
    required this.imageUrl,
    required this.onRetry,
  });

  void _onSharePressed(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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

  void _onCopyPressed(
    BuildContext context,
    String textToCopy,
    String successMessage,
  ) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successMessage,
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
                onTap: () =>
                    _onSharePressed(context, l10n.resultFeatureInDevelopment),
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
                onTap: () => _onCopyPressed(
                  context,
                  imageUrl ?? 'https://vocabik.com',
                  l10n.resultCopiedToClipboard,
                ),
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
          onTap: () =>
              _onSharePressed(context, l10n.resultFeatureInDevelopment),
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
    if (status == ScoreCardStatus.loading ||
        status == ScoreCardStatus.initial) {
      return AppShimmer(child: Container(color: colors.surfaceCard));
    } else if (status == ScoreCardStatus.offline) {
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
              onPressed: onRetry,
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
    } else if (status == ScoreCardStatus.error) {
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
              onPressed: onRetry,
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
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
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
  }) {
    return PrimaryButton(
      leadingIcon: icon,
      text: label,
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

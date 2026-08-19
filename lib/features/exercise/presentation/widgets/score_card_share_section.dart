import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

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
          style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onCopyPressed(BuildContext context, String textToCopy, String successMessage) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successMessage,
          style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttonBg = isDark ? const Color(0xFF1E2038) : const Color(0xFFE8ECF4);
    final buttonBorder = isDark ? const Color(0xFF2C3050) : const Color(0xFFD0D8E8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.resultShare,
          style: GoogleFonts.nunito(
            fontSize: 20,
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
        const SizedBox(height: AppSpacing.md),

        // Action Buttons Row: Instagram & Copy
        Row(
          children: [
            // Instagram Button
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: SvgPicture.asset(
                  'assets/result_screen/share_ig_icon.svg',
                  width: 20,
                  height: 20,
                ),
                label: l10n.resultInstagram,
                backgroundColor: buttonBg,
                borderColor: buttonBorder,
                textColor: colors.textPrimary,
                onTap: () => _onSharePressed(context, l10n.resultFeatureInDevelopment),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Copy Button
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: SvgPicture.asset(
                  'assets/result_screen/copy_icon.svg',
                  width: 20,
                  height: 20,
                ),
                label: l10n.resultCopy,
                backgroundColor: buttonBg,
                borderColor: buttonBorder,
                textColor: colors.textPrimary,
                onTap: () => _onCopyPressed(
                  context,
                  imageUrl ?? 'https://vocabik.com',
                  l10n.resultCopiedToClipboard,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Challenge a Friend Button
        _buildActionButton(
          context: context,
          icon: SvgPicture.asset(
            'assets/result_screen/challenge_icon.svg',
            width: 20,
            height: 20,
          ),
          label: l10n.resultChallengeFriend,
          backgroundColor: buttonBg,
          borderColor: buttonBorder,
          textColor: colors.textPrimary,
          onTap: () => _onSharePressed(context, l10n.resultFeatureInDevelopment),
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
    if (status == ScoreCardStatus.loading || status == ScoreCardStatus.initial) {
      return AppShimmer(
        child: Container(
          color: colors.surfaceCard,
        ),
      );
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
              style: GoogleFonts.nunito(
                fontSize: 14,
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
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
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
              style: GoogleFonts.nunito(
                fontSize: 14,
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
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
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
          return AppShimmer(
            child: Container(
              color: colors.surfaceCard,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: colors.surfaceCard,
            child: Center(
              child: Text(
                l10n.resultScoreCardError,
                style: GoogleFonts.nunito(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(
      color: colors.surfaceCard,
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm + 2,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

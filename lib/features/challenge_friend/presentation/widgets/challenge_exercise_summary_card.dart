import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/app_shimmer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';

class ChallengeExerciseSummaryCard extends StatelessWidget {
  final String videoTitle;
  final String artist;
  final String cefrLevel;
  final int blanksCount;
  final int accuracyScore;
  final String youtubeVideoId;

  const ChallengeExerciseSummaryCard({
    super.key,
    required this.videoTitle,
    required this.artist,
    required this.cefrLevel,
    required this.blanksCount,
    required this.accuracyScore,
    this.youtubeVideoId = '',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final parts = <String>[];
    if (artist.isNotEmpty) parts.add(artist);
    if (cefrLevel.isNotEmpty) parts.add(cefrLevel.toUpperCase());
    parts.add(l10n.challengeBlanksCount(blanksCount));
    final subtitleText = parts.join(' · ');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          // Video Thumbnail / Gradient fallback
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 76,
              height: 48,
              child: youtubeVideoId.isNotEmpty
                  ? Image.network(
                      'https://img.youtube.com/vi/$youtubeVideoId/mqdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildGradientBox(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const AppShimmer(
                          child: ColoredBox(color: Colors.white),
                        );
                      },
                    )
                  : _buildGradientBox(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  videoTitle.isNotEmpty ? videoTitle : 'Exercise',
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitleText,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Accuracy Score Badge
          Text(
            '$accuracyScore%',
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg2,
              fontWeight: FontWeight.w800,
              color: colors.primaryAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBox() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF5E7E), Color(0xFFFF9966)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

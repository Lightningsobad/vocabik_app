import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/daily_challenge_config_entity.dart';

class DailyChallengeVideoCard extends StatelessWidget {
  final DailyChallengeConfigEntity? config;
  final int participantCount;
  final VoidCallback? onTap;

  const DailyChallengeVideoCard({
    super.key,
    required this.config,
    required this.participantCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final thumbnailUrl = config?.thumbnailUrl ?? '';
    final videoTitle = config?.videoTitle.isNotEmpty == true
        ? config!.videoTitle
        : 'Daily Challenge Video';

    final cardWidget = Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      height: 220,
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg3),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Thumbnail with cache size optimization
            if (thumbnailUrl.isNotEmpty)
              Transform.scale(
                scale: 1.34,
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 800,
                  cacheHeight: 450,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colors.surfaceCard,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: colors.textSecondary,
                        size: 32,
                      ),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: colors.surfaceCard,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                color: colors.surfaceCard,
                child: Center(
                  child: Icon(
                    Icons.music_video_rounded,
                    color: colors.textSecondary,
                    size: 40,
                  ),
                ),
              ),

            // 2. Gradient Overlay for text contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),

            // 3. Bottom Info (Title & Participants)
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Video Title
                  Text(
                    videoTitle,
                    style: AppTextStyles.custom(
                      color: Colors.white,
                      fontSize: AppFontSize.xl3,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Participant count
                  Row(
                    children: [
                      Image.asset(
                        'assets/daily_challenge_screen/people_icon.png',
                        width: 16,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.people_alt_rounded,
                              size: 16,
                              color: AppColors.streak,
                            ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.dailyChallengeParticipants(participantCount),
                          style: AppTextStyles.custom(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return BounceWrapper(onTap: onTap, child: cardWidget);
    }

    return cardWidget;
  }
}

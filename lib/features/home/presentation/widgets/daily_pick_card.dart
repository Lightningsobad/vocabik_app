import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DailyPickCard extends StatelessWidget {
  final DailyPickEntity dailyPick;

  const DailyPickCard({super.key, required this.dailyPick});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: BounceWrapper(
        onTap: () {
          if (dailyPick.videoId.isNotEmpty) {
            context.push('/video/${dailyPick.videoId}');
          }
        },
        child: Container(
          height: 215,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg2),
            color: colors.surfaceCard,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg2),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background Thumbnail
                if (dailyPick.thumbnailUrl.isNotEmpty)
                  Transform.scale(
                    scale: 1.34,
                    child: Image.network(
                      dailyPick.thumbnailUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 800,
                      cacheHeight: 430,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: colors.surfaceCard,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colors.textSecondary,
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
                  Container(color: colors.surfaceCard),

                // 2. Gradient Overlay for readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),

                // 3. Top-left Badge (DAILY PICK)
                Positioned(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  child: CourseTagBadge(
                    text: l10n.homeDailyPickTag,
                    type: CourseTagType.dailyPick,
                  ),
                ),

                // 4. Center Play Button with Glow
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 32,
                    ),
                  ),
                ),

                // 5. Bottom Info (CEFR Level & Title)
                Positioned(
                  bottom: AppSpacing.md,
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (dailyPick.cefrLevel.isNotEmpty) ...[
                        Row(
                          children: [CourseTagBadge(text: dailyPick.cefrLevel)],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      Text(
                        dailyPick.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.custom(
                          color: Colors.white,
                          fontSize: AppFontSize.xl5,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class AlsoForYouVideoCard extends StatelessWidget {
  final PersonalizedSlotEntity slot;

  const AlsoForYouVideoCard({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: () {
        if (slot.videoId.isNotEmpty) {
          context.push('/video/${slot.videoId}');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm2),
        padding: const EdgeInsets.all(AppSpacing.sm2),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          children: [
            // Thumbnail container with play button
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: 110,
                height: 65,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (slot.thumbnailUrl.isNotEmpty)
                      Transform.scale(
                        scale: 1.34,
                        child: Image.network(
                          slot.thumbnailUrl,
                          fit: BoxFit.cover,
                          cacheWidth: 220,
                          cacheHeight: 130,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(color: colors.surfaceCard),
                    // Dark overlay with play icon
                    Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slot.title,
                    style: AppTextStyles.custom(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (slot.cefrLevel.isNotEmpty)
                    Row(children: [CourseTagBadge(text: slot.cefrLevel)]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

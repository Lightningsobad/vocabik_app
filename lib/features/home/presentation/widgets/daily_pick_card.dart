import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/utils/number_format_utils.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: BounceWrapper(
        onTap: () {
          if (dailyPick.videoId.isNotEmpty) {
            context.push('/home/video/${dailyPick.videoId}');
          }
        },
        child: Container(
          height: 263,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
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
            borderRadius: BorderRadius.circular(AppRadius.xl),
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
                        return const AppShimmer(
                          child: ColoredBox(color: Colors.white),
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
                  top: AppSpacing.mdt,
                  left: AppSpacing.mdt,
                  child: CourseTagBadge(
                    text: l10n.homeDailyPickTag,
                    type: CourseTagType.dailyPick,
                    textStyle: AppTextStyles.custom(
                      fontSize: AppFontSize.sm,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.tnn,
                    ),
                  ),
                ),

                // 4. Center Play Button with Glow
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
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

                // 5. Bottom Info (CEFR Level, Category, Duration, Title, Artist, Practiced)
                Positioned(
                  bottom: AppSpacing.xl,
                  left: AppSpacing.mdt,
                  right: AppSpacing.mdt,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row with CEFR Level, Category, Duration
                      if (dailyPick.cefrLevel.isNotEmpty ||
                          dailyPick.category.isNotEmpty ||
                          dailyPick.durationSeconds > 0) ...[
                        Row(
                          children: [
                            if (dailyPick.cefrLevel.isNotEmpty) ...[
                              CourseTagBadge(text: dailyPick.cefrLevel),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            if (dailyPick.category.isNotEmpty) ...[
                              CourseTagBadge(
                                text: dailyPick.category,
                                type: CourseTagType.category,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                border: const Border(),
                                leadingIcon: Image.asset(
                                  'assets/home_screen/music_icon.png',
                                  width: 16,
                                  height: 16,
                                ),
                                textStyle: AppTextStyles.custom(
                                  color: Colors.white,
                                  fontSize: AppFontSize.tnn,
                                  fontWeight: FontWeight.w900,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm2,
                                  vertical: AppSpacing.xs,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            if (dailyPick.durationSeconds > 0) ...[
                              Image.asset(
                                'assets/home_screen/timer_icon.png',
                                width: 14,
                                height: 14,
                                alignment: Alignment.center,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                _formatDuration(dailyPick.durationSeconds),
                                style: AppTextStyles.custom(
                                  color: Colors.white,
                                  fontSize: AppFontSize.sm,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],

                      // Title
                      Text(
                        dailyPick.title.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.custom(
                          color: Colors.white,
                          fontSize: AppFontSize.xl6,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),

                      // Artist & Practiced Count
                      if (dailyPick.artist.isNotEmpty ||
                          dailyPick.practiced >= 0) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            if (dailyPick.artist.isNotEmpty) ...[
                              Flexible(
                                child: Text(
                                  dailyPick.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.custom(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: AppFontSize.lg,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                            if (dailyPick.artist.isNotEmpty &&
                                dailyPick.practiced >= 0) ...[
                              Text(
                                ' · ',
                                style: AppTextStyles.custom(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: AppFontSize.md,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                            if (dailyPick.practiced >= 0) ...[
                              Image.asset(
                                'assets/home_screen/people_icon.png',
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                l10n.homePracticed(
                                  NumberFormatUtils.formatCompact(
                                    dailyPick.practiced,
                                  ),
                                ),
                                style: AppTextStyles.custom(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: AppFontSize.lg,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
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

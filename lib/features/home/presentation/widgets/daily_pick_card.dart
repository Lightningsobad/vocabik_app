import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/features/home/presentation/models/home_mock_data.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';

class DailyPickCard extends StatelessWidget {
  final MockCourseModel course;
  final bool isLoading;

  const DailyPickCard({
    super.key,
    required this.course,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.xl13),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      );
    }

    final gradientColors = generateRandomGradient(colors);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: BounceWrapper(
        onTap: () {
          context.push('/video/${course.id}');
        },
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: AppSpacing.xl13),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: CourseTagBadge(
                      text: AppLocalizations.of(context)!.homeDailyPickTag,
                      type: CourseTagType.dailyPick,
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.md,
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CourseTagBadge(text: course.level),
                            const SizedBox(width: AppSpacing.sm),
                            CourseTagBadge(
                              text: course.category,
                              type: CourseTagType.category,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: AppFontSize.md,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  course.duration,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          course.title,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: AppFontSize.xl5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${course.subtitle} · \uD83D\uDC65 ${AppLocalizations.of(context)!.homePracticed(course.practicersCount.toString())}',
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: AppFontSize.lg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: AppSpacing.xl6,
                      height: AppSpacing.xl6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: AppFontSize.xl4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

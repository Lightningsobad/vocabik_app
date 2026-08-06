import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/home/presentation/models/home_mock_data.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

import 'course_tag_badge.dart';

class SharedCourseCard extends StatelessWidget {
  final MockCourseModel course;
  final bool isLoading;
  final double width;

  const SharedCourseCard({
    super.key,
    required this.course,
    this.isLoading = false,
    this.width = AppSpacing.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      );
    }

    final gradientColors = generateRandomGradient(colors);

    return BounceWrapper(
      onTap: () {},
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: AppSpacing.xl12_2,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  topRight: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    right: AppSpacing
                        .xl4, // 40.0, enough space to avoid overlapping the completed tag
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: [
                        CourseTagBadge(text: course.level),
                        if (course.isNew)
                          CourseTagBadge(
                            text: l10n.homeNewTag,
                            type: CourseTagType.newTag,
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: course.isCompleted
                        ? const CourseTagBadge(
                            text: '',
                            type: CourseTagType.completed,
                          )
                        : const SizedBox(),
                  ),
                  Positioned(
                    bottom: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        course.duration,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: AppFontSize.tn2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  if (course.category ==
                      'Talk') // Play button in middle if it's a talk
                    Center(
                      child: Container(
                        width: AppSpacing.xl5,
                        height: AppSpacing.xl5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: AppFontSize.xl6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.nunito(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.mdt,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.subtitle,
                    style: GoogleFonts.nunito(
                      color: colors.textSecondary,
                      fontSize: AppFontSize.sm,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CourseTagBadge(
                          text: course.category,
                          type: CourseTagType.category,
                        ),
                      ),
                      if (course.practicersCount > 0) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          l10n.homePracticed(course.practicersCount.toString()),
                          style: GoogleFonts.nunito(
                            color: colors.textSecondary,
                            fontSize: AppFontSize.tn2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
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

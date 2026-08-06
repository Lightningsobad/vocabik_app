import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/home/presentation/models/home_mock_data.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';

class HorizontalCourseCard extends StatelessWidget {
  final MockCourseModel course;

  const HorizontalCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final gradientColors = generateRandomGradient(colors);

    return BounceWrapper(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            // Play Button Thumbnail
            Container(
              width: AppSpacing.xl12,
              height: AppSpacing.xl7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: AppFontSize.xl6,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.nunito(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CourseTagBadge(text: course.level),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${course.category} · ${course.duration}',
                        style: GoogleFonts.nunito(
                          color: colors.textSecondary,
                          fontSize: AppFontSize.sm,
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
  }
}

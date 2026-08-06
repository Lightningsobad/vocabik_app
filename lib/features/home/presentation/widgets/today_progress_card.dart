import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_progress_bar.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class TodayProgressCard extends StatelessWidget {
  final int completedLessons;
  final int totalLessons;

  const TodayProgressCard({
    super.key,
    required this.completedLessons,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.tn,
                  children: [
                    Text(
                      l10n.homeTodayProgress,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontSize: AppFontSize.lg2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Text(
                        l10n.homeLessons(completedLessons, totalLessons),
                        style: GoogleFonts.nunito(
                          color: colors.textSecondary,
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppProgressBar(
                  progress: progress,
                  height: 6.0,
                  backgroundColor: colors.borderSubtle.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          BounceWrapper(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.streak,
                    size: AppFontSize.xl,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.homeUnlimited,
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

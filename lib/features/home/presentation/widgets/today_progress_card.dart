import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_progress_bar.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      padding: const EdgeInsets.all(AppSpacing.lg1),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.homeTodayProgress,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Text(
                        l10n
                            .homeLessons(completedLessons, totalLessons)
                            .replaceAll(' lessons', '')
                            .replaceAll('/', 'of'),
                        style: GoogleFonts.nunito(
                          color: colors.textSecondary,
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppProgressBar(
                  progress: progress,
                  height: 9.0,
                  backgroundColor: colors.background,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          BounceWrapper(
            onTap: () {
              context.push('/home/pricing');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 17.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF31244F)
                    : const Color(0xFFF4EAFD),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF603791)
                      : const Color(0xFFD4AEF5),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/home_screen/xp_icon.svg',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.homeUnlimited,
                    style: GoogleFonts.nunito(
                      color: colors.premiumBackground,
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

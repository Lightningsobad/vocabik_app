import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ResultGamificationCards extends StatelessWidget {
  final String cefrLevel;
  final int xpEarned;
  final int dayStreak;

  const ResultGamificationCards({
    super.key,
    required this.cefrLevel,
    this.xpEarned = 20,
    this.dayStreak = 5,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final xpCardBg = isDark ? const Color(0xFF0D252E) : const Color(0xFFE6F8FA);
    final xpCardBorder = isDark ? const Color(0xFF15535E) : const Color(0xFFB2EBF2);

    final streakCardBg = isDark ? const Color(0xFF291E13) : const Color(0xFFFFF8E7);
    final streakCardBorder = isDark ? const Color(0xFF5E4018) : const Color(0xFFFFE0B2);

    final badgeCardBg = isDark ? const Color(0xFF1B1B33) : const Color(0xFFF3E8FF);
    final badgeCardBorder = isDark ? const Color(0xFF33335A) : const Color(0xFFE9D5FF);

    return Column(
      children: [
        // XP & Streak Row
        Row(
          children: [
            // XP Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: xpCardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: xpCardBorder, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      '+$xpEarned',
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: colors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tn),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '⚡',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l10n.resultXpEarned,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Streak Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: streakCardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: streakCardBorder, width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$dayStreak',
                          style: GoogleFonts.nunito(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.tn),
                    Text(
                      l10n.resultDayStreak,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // New Badge Card
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm + 2,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: badgeCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: badgeCardBorder, width: 1.5),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/result_screen/medal_icon.svg',
                width: 36,
                height: 36,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.resultNewBadge(cefrLevel.toUpperCase()),
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.resultCompletedFirstExercise(cefrLevel.toUpperCase()),
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

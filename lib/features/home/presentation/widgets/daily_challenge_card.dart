import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isDark
        ? const Color(0xFF085959)
        : const Color(0xFFAED7E6);
    final gradientColors = isDark
        ? [const Color(0xFF0B2A33), const Color(0xFF0D1420)]
        : [const Color(0xFFDCEAF2), const Color(0xFFF2F3F7)];
    final timeColor = isDark
        ? const Color(0xFFFFB13D)
        : const Color(0xFFF59F0A);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/home_screen/trophy.svg',
            width: 32,
            height: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeDailyChallenge,
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFontSize.lg2,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, color: timeColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '08:42',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: timeColor,
                            fontSize: AppFontSize.mdt,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Blinding Lights · 1,247 ng...', // Mock subtitle
                  style: GoogleFonts.nunito(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: AppFontSize.sm,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.tn),
          Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            size: 22,
          ),
        ],
      ),
    );
  }
}

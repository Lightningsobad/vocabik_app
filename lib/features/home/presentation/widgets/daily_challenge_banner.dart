import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DailyChallengeBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeLeft;

  const DailyChallengeBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: BounceWrapper(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                    ]
                  : [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.02),
                    ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // Trophy Icon
              const Text(
                '\uD83C\uDFC6',
                style: TextStyle(fontSize: AppFontSize.xl4),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeDailyChallenge,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontSize: AppFontSize.xl,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$title · $subtitle',
                      style: GoogleFonts.nunito(
                        color: colors.textSecondary,
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: AppFontSize.md,
                    color: AppColors.streak,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeLeft,
                    style: GoogleFonts.nunito(
                      color: AppColors.streak,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppFontSize.md,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

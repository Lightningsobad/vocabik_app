import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final year = DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl3,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo text
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
              children: [
                const TextSpan(text: 'Vocab'),
                TextSpan(
                  text: 'ik',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Links Row 1
          Row(
            children: [
              _buildFooterLink(l10n.homePricing, colors.textSecondary),
              const SizedBox(width: 24),
              _buildFooterLink(l10n.homePrivacyPolicy, colors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          // Links Row 2 & Copyright
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFooterLink(l10n.homeTerms, colors.textSecondary),
              Text(
                '© $year Vocabik',
                style: GoogleFonts.nunito(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

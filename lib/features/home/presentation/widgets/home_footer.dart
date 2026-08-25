import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final year = DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Divider line
          Divider(color: colors.borderSubtle, height: 1, thickness: 1),
          const SizedBox(height: AppSpacing.xl),

          // 2. Logo & Links in a single horizontal row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo text
              RichText(
                text: TextSpan(
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.lg2,
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
              const SizedBox(width: AppSpacing.lg),
              _buildFooterLink(
                text: l10n.homePricing,
                color: colors.textSecondary,
                onTap: () {
                  context.push('/home/pricing');
                },
              ),
              const SizedBox(width: AppSpacing.md2),
              _buildFooterLink(
                text: l10n.homePrivacyPolicy,
                color: colors.textSecondary,
                onTap: () {
                  context.push('/home/privacy-policy');
                },
              ),
              const SizedBox(width: AppSpacing.md2),
              _buildFooterLink(
                text: l10n.homeTerms,
                color: colors.textSecondary,
                onTap: () {
                  context.push('/home/terms-of-service');
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. Copyright on the right
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '© $year Vocabik',
              style: AppTextStyles.custom(
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink({
    required String text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return BounceWrapper(
      onTap: onTap,
      child: Text(
        text,
        style: AppTextStyles.custom(
          color: color,
          fontSize: AppFontSize.mdt,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import 'legal_section_item.dart';

class PrivacyPolicyContentView extends StatelessWidget {
  const PrivacyPolicyContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.privacyPolicyTitle,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.xl4,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.tn),
          Text(
            l10n.legalLastUpdated(l10n.legalLastUpdatedDefaultDate),
            style: AppTextStyles.custom(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Summary box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.successBackground.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: colors.successBorder.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  color: colors.textSecondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '${l10n.privacySummaryTitle} ',
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: l10n.privacySummaryContent,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl2),
          LegalSectionItem(
            title: l10n.privacySection1Title,
            content: l10n.privacySection1Content,
          ),
          LegalSectionItem(
            title: l10n.privacySection2Title,
            content: l10n.privacySection2Content,
          ),
          LegalSectionItem(
            title: l10n.privacySection3Title,
            content: l10n.privacySection3Content,
          ),
          LegalSectionItem(
            title: l10n.privacySection4Title,
            content: l10n.privacySection4Content,
          ),
          LegalSectionItem(
            title: l10n.privacySection5Title,
            content: l10n.privacySection5Content,
          ),
          LegalSectionItem(
            title: l10n.privacySection6Title,
            content: l10n.privacySection6Content,
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () => launchUrl(
              Uri.parse('mailto:privacy@vocabik.com'),
              mode: LaunchMode.externalApplication,
            ),
            child: Text(
              l10n.privacyContact,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.primaryAccent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl6),
        ],
      ),
    );
  }
}

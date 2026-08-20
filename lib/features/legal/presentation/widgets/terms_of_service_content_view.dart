import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import 'legal_section_item.dart';

class TermsOfServiceContentView extends StatelessWidget {
  const TermsOfServiceContentView({super.key});

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
            l10n.termsOfServiceTitle,
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
          const SizedBox(height: AppSpacing.xl2),
          LegalSectionItem(
            title: l10n.tosSection1Title,
            content: l10n.tosSection1Content,
          ),
          LegalSectionItem(
            title: l10n.tosSection2Title,
            content: l10n.tosSection2Content,
          ),
          LegalSectionItem(
            title: l10n.tosSection3Title,
            content: l10n.tosSection3Content,
          ),
          LegalSectionItem(
            title: l10n.tosSection4Title,
            content: l10n.tosSection4Content,
          ),
          LegalSectionItem(
            title: l10n.tosSection5Title,
            content: l10n.tosSection5Content,
          ),
          LegalSectionItem(
            title: l10n.tosSection6Title,
            content: l10n.tosSection6Content,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.tosContact,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl6),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

class AccountTabContent extends StatelessWidget {
  const AccountTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AccountActionItem(
            title: l10n.accountExportData,
            hasArrow: true,
            onTap: () {
              // TODO: Implement export data
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AccountActionItem(
            title: l10n.accountLogOut,
            hasArrow: false,
            onTap: () {
              // TODO: Implement log out
            },
          ),
          const SizedBox(height: AppSpacing.md),
          DangerActionItem(
            title: l10n.accountDeletePermanently,
            onTap: () {
              // TODO: Implement delete account permanently
            },
          ),
        ],
      ),
    );
  }
}

class AccountActionItem extends StatelessWidget {
  final String title;
  final bool hasArrow;
  final VoidCallback onTap;

  const AccountActionItem({
    super.key,
    required this.title,
    this.hasArrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BounceWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(
                color: colors.textPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasArrow)
              Icon(
                Icons.arrow_forward_rounded,
                color: colors.textPrimary,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}

class DangerActionItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DangerActionItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BounceWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.dangerSoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: colors.danger.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.nunito(
            color: colors.danger,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

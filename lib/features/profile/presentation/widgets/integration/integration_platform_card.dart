import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

import 'integration_status_indicator.dart';
import 'dropdown_selector.dart';

class IntegrationPlatformCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final List<String>? instructions;
  final bool showConfig;

  const IntegrationPlatformCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.instructions,
    this.showConfig = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontSize: AppSpacing.lg2,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tn),
                    Text(
                      description,
                      style: GoogleFonts.nunito(
                        color: colors.textSecondary,
                        fontSize: AppSpacing.md2,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const IntegrationStatusIndicator(),
            ],
          ),
          if (instructions != null && instructions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.background, // Tối hơn surfaceCard một chút
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: instructions!
                    .map(
                      (instruction) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.tn),
                        child: Text(
                          instruction,
                          style: GoogleFonts.nunito(
                            color: colors.textSecondary,
                            fontSize: AppSpacing.md3,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          if (showConfig) ...[
            const SizedBox(height: AppSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 250) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownSelector(
                        label: l10n.timeToReceiveLabel,
                        value: "07:00",
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownSelector(
                        label: l10n.levelLabel,
                        value: "Theo profile (B1)",
                        onTap: () {},
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: DropdownSelector(
                        label: l10n.timeToReceiveLabel,
                        value: "07:00",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownSelector(
                        label: l10n.levelLabel,
                        value: "Theo profile (B1)",
                        onTap: () {},
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: title == "Telegram Bot"
                  ? l10n.connectTelegramBtn
                  : l10n.connectZaloBtn,
              onPressed: () {}, // Không làm gì
            ),
          ],
        ],
      ),
    );
  }
}

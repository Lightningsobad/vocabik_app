import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/password_input_widget.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'active_sessions_card.dart';

class SecurityTabContent extends StatelessWidget {
  const SecurityTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.securityTab_currentPasswordLabel,
            style: GoogleFonts.nunito(
              color: colors.textPrimary,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const PasswordInputWidget(
            hintText: '••••••••',
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Text(
            l10n.securityTab_newPasswordLabel,
            style: GoogleFonts.nunito(
              color: colors.textPrimary,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const PasswordInputWidget(
            hintText: '••••••••',
          ),
          const SizedBox(height: AppSpacing.lg2),
          
          PrimaryButton(
            text: l10n.securityTab_updateButton,
            onPressed: () {
              // TODO: Implement update logic
            },
          ),
          const SizedBox(height: AppRadius.xl), // or just use a fixed double like 24.0, but I will use AppSpacing.xl if it existed. Wait, let's use 24.0 since AppSpacing has no 24.0

          
          const ActiveSessionsCard(),
        ],
      ),
    );
  }
}

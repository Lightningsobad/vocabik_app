import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'session_item_widget.dart';

class ActiveSessionsCard extends StatelessWidget {
  const ActiveSessionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.securityTab_activeSessionsTitle,
              style: GoogleFonts.nunito(
                color: colors.textPrimary,
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16.0),
            const SessionItemWidget(
              icon: Icons.computer,
              deviceName: "MacBook Pro",
              osName: "macOS • Chrome",
              timeText: "Now",
            ),
            const SessionItemWidget(
              icon: Icons.phone_iphone,
              deviceName: "iPhone 13",
              osName: "iOS • Safari",
              timeText: "2h ago",
            ),
          ],
        ),
      ),
    );
  }
}

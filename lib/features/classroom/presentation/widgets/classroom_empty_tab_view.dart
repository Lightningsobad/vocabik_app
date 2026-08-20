import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ClassroomEmptyTabView extends StatelessWidget {
  final String? customMessage;

  const ClassroomEmptyTabView({
    super.key,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 56.0,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              customMessage ?? l10n.noDataAvailable,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

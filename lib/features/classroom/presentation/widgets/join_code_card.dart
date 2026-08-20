import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class JoinCodeCard extends StatelessWidget {
  final String joinCode;

  const JoinCodeCard({
    super.key,
    required this.joinCode,
  });

  void _copyToClipboard(BuildContext context, String message) {
    Clipboard.setData(ClipboardData(text: joinCode));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colors.borderSubtle,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Text(
            '${l10n.joinCode} ',
            style: GoogleFonts.nunito(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              joinCode,
              style: GoogleFonts.nunito(
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
                color: colors.primaryAccent,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          BounceWrapper(
            onTap: () => _copyToClipboard(context, l10n.resultCopiedToClipboard),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: colors.tabUnselectedBackground,
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(
                  color: colors.tabUnselectedBorder,
                  width: 1.0,
                ),
              ),
              child: Text(
                l10n.copy,
                style: GoogleFonts.nunito(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

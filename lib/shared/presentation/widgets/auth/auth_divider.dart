import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Divider(color: colors?.borderSubtle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            l10n.orText,
            style: TextStyle(
              fontSize: 12,
              color: colors?.textSecondary ?? Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: colors?.borderSubtle),
        ),
      ],
    );
  }
}

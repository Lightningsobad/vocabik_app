import 'package:flutter/material.dart';
import 'package:vocabik_app/features/auth/presentation/models/password_strength.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

export 'package:vocabik_app/features/auth/presentation/models/password_strength.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;
    
    int activeBars = 0;
    Color indicatorColor = colors?.textSecondary ?? Colors.grey;
    String strengthText = '';

    switch (strength) {
      case PasswordStrength.none:
        activeBars = 0;
        strengthText = '';
        break;
      case PasswordStrength.weak:
        activeBars = 1;
        indicatorColor = colors?.danger ?? const Color(0xFFFF5C72);
        strengthText = l10n.passwordStrengthWeak;
        break;
      case PasswordStrength.medium:
        activeBars = 2;
        indicatorColor = Colors.orange;
        strengthText = l10n.passwordStrengthMedium;
        break;
      case PasswordStrength.strong:
        activeBars = 3;
        indicatorColor = colors?.primaryAccent ?? const Color(0xFF00E5CC);
        strengthText = l10n.passwordStrengthStrong;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                decoration: BoxDecoration(
                  color: index < activeBars
                      ? indicatorColor
                      : colors?.borderSubtle ?? const Color(0xFF2A2A3D),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (strength != PasswordStrength.none)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              strengthText,
              style: GoogleFonts.nunito(
                color: indicatorColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

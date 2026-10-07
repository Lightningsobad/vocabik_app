import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class VocabikBrandText extends StatelessWidget {
  final double? fontSize;

  const VocabikBrandText({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final effectiveFontSize = fontSize ?? 19.0;

    return RichText(
      text: TextSpan(
        style: GoogleFonts.nunito(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.03 * effectiveFontSize,
          color: colors.textPrimary,
        ),
        children: [
          const TextSpan(
            text: 'Vocab',
          ),
          TextSpan(
            text: 'ik',
            style: TextStyle(
              color: colors.primaryAccent, // Màu Primary Accent cho phần 'ik'
            ),
          ),
        ],
      ),
    );
  }
}

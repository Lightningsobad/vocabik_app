import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class VocabikBrandText extends StatelessWidget {
  const VocabikBrandText({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return RichText(
      text: TextSpan(
        style: GoogleFonts.nunito(
          fontSize: 19,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.03 * 19,
          color: colors.textPrimary,
        ),
        children: [
          const TextSpan(
            text: 'Vocab',
          ),
          const TextSpan(
            text: 'ik',
            style: TextStyle(
              color: AppColors.accent, // Màu Cyan cho phần 'ik'
            ),
          ),
        ],
      ),
    );
  }
}

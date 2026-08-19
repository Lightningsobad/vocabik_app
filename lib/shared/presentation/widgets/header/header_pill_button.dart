import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class HeaderPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const HeaderPillButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colors.surfaceCard,
          border: Border.all(color: colors.borderSubtle),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

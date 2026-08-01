import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class HeaderCircleButton extends StatelessWidget {
  final Widget? icon;
  final String? text;
  final VoidCallback onTap;

  const HeaderCircleButton({
    super.key,
    this.icon,
    this.text,
    required this.onTap,
  }) : assert(icon != null || text != null, 'Must provide either icon or text');

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surfaceCard,
          border: Border.all(color: colors.borderSubtle),
        ),
        alignment: Alignment.center,
        child: text != null
            ? Text(
                text!,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colors.textSecondary,
                ),
              )
            : icon,
      ),
    );
  }
}

import 'package:flutter/material.dart';
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceCard, // Nền xám nhạt (surface-card-2)
            border: Border.all(color: colors.borderSubtle), // Viền xám mờ (border-default)
          ),
          alignment: Alignment.center,
          child: text != null
              ? Text(
                  text!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Display',
                    color: colors.textSecondary, // text-secondary
                  ),
                )
              : icon,
        ),
      ),
    );
  }
}

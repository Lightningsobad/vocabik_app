import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class HeaderPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const HeaderPillButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: colors.tabUnselectedBackground,
          border: Border.all(color: colors.borderSubtle, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w900,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class StatBadge extends StatelessWidget {
  final String? iconAsset;
  final String? emoji;
  final String valueText;
  final Color color;

  const StatBadge({
    super.key,
    this.iconAsset,
    this.emoji,
    required this.valueText,
    required this.color,
  }) : assert(
         iconAsset != null || emoji != null,
         'Must provide iconAsset or emoji',
       );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconAsset != null)
          SvgPicture.asset(iconAsset!, width: 16, height: 16)
        else if (emoji != null)
          Text(emoji!, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          valueText,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.mdt,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

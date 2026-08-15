import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class VocabikLogo extends StatelessWidget {
  final double size;
  
  const VocabikLogo({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.ink950, // Nền màu tối
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: AppColors.accentBorder), // Viền nhẹ
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Biểu tượng nút play màu Primary Accent
          Icon(
            Icons.play_arrow_rounded,
            color: colors.primaryAccent,
            size: size * 0.66,
          ),
          // Đường gạch dưới màu Tím
          Positioned(
            bottom: size * 0.16,
            child: Container(
              width: size * 0.43,
              height: size * 0.08,
              decoration: BoxDecoration(
                color: AppColors.premium, // Màu Tím
                borderRadius: BorderRadius.circular(size * 0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

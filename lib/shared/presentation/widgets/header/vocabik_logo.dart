import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class VocabikLogo extends StatelessWidget {
  const VocabikLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.ink950, // Nền màu tối
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.accentBorder), // Viền nhẹ
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Biểu tượng nút play màu Cyan
          const Icon(
            Icons.play_arrow_rounded,
            color: AppColors.accent, // Màu Cyan
            size: 20,
          ),
          // Đường gạch dưới màu Tím
          Positioned(
            bottom: 5,
            child: Container(
              width: 13,
              height: 2.4,
              decoration: BoxDecoration(
                color: AppColors.premium, // Màu Tím
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

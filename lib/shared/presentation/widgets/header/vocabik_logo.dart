import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class VocabikLogo extends StatelessWidget {
  final double size;
  final double? borderWidth;
  
  const VocabikLogo({super.key, this.size = 30, this.borderWidth});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final effectiveBorderWidth =
        borderWidth ?? (size > 50 ? size * 0.025 : 1.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.logoBackground, // Nền logo
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: colors.logoBorder,
          width: effectiveBorderWidth,
        ), // Viền logo
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Biểu tượng nút play
          Icon(
            Icons.play_arrow_rounded,
            color: colors.logoPlay,
            size: size * 0.66,
          ),
          // Đường gạch dưới
          Positioned(
            bottom: size * 0.16,
            child: Container(
              width: size * 0.43,
              height: size * 0.08,
              decoration: BoxDecoration(
                color: colors.logoUnderline, // Màu đường gạch dưới
                borderRadius: BorderRadius.circular(size * 0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

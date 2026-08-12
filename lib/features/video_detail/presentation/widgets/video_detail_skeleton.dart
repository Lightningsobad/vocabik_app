import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class VideoDetailSkeleton extends StatelessWidget {
  const VideoDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar space
          const SizedBox(height: 56),
          // Thumbnail placeholder
          Shimmer.fromColors(
            baseColor: isDark ? colors.surfaceCard : Colors.grey[300]!,
            highlightColor: isDark ? colors.borderSubtle : Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              height: 200,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Tags placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Shimmer.fromColors(
              baseColor: isDark ? colors.surfaceCard : Colors.grey[300]!,
              highlightColor: isDark ? colors.borderSubtle : Colors.grey[100]!,
              child: Row(
                children: [
                  Container(width: 40, height: 24, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(12))),
                  const SizedBox(width: 8),
                  Container(width: 60, height: 24, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(12))),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Title placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Shimmer.fromColors(
              baseColor: isDark ? colors.surfaceCard : Colors.grey[300]!,
              highlightColor: isDark ? colors.borderSubtle : Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, height: 28, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 8),
                  Container(width: 200, height: 28, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 12),
                  Container(width: 120, height: 16, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Cards placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Shimmer.fromColors(
              baseColor: isDark ? colors.surfaceCard : Colors.grey[300]!,
              highlightColor: isDark ? colors.borderSubtle : Colors.grey[100]!,
              child: Row(
                children: [
                  Expanded(
                    child: Container(height: 80, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(16))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(height: 80, decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(16))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

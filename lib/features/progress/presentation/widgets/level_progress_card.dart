import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import '../../domain/entities/gamification.dart';
import 'shimmer_block.dart';

class LevelProgressCard extends StatelessWidget {
  final bool isLoading;
  final Gamification? gamification;

  const LevelProgressCard({
    super.key,
    this.isLoading = false,
    this.gamification,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final levelInfo = gamification?.levelInfo;
    final currentXp = levelInfo?.currentXpInLevel ?? 0;
    final maxXp = levelInfo?.maxXpInLevel ?? 100;
    final progress = maxXp > 0 ? (currentXp / maxXp).clamp(0.0, 1.0) : 0.0;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isLoading)
                const ShimmerBlock(width: 120, height: 24)
              else
                Text(
                  levelInfo?.currentLevel ?? 'Beginner',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
              if (isLoading)
                const ShimmerBlock(width: 80, height: 16)
              else
                Text(
                  '$currentXp / $maxXp XP',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (isLoading)
            const ShimmerBlock(height: 8)
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                minHeight: 8.0,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          if (isLoading)
            const ShimmerBlock(width: 150, height: 16)
          else
            Text(
              '→ Next: ${levelInfo?.nextLevel ?? 'Intermediate'}',
              style: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import '../../domain/entities/gamification.dart';
import '../../domain/entities/daily_streak.dart';
import 'shimmer_block.dart';

class StreakCalendarCard extends StatelessWidget {
  final bool isLoading;
  final Gamification? gamification;
  final DailyStreak? dailyStreak;

  const StreakCalendarCard({
    super.key,
    this.isLoading = false,
    this.gamification,
    this.dailyStreak,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
              Text(
                '30-day streak',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
              ),
              if (isLoading)
                const ShimmerBlock(width: 100, height: 20)
              else
                Row(
                  children: [
                    const Icon(Icons.ac_unit, size: 16, color: Colors.cyan),
                    const SizedBox(width: 4),
                    Text(
                      'Streak Freeze: ${gamification?.streakFreeze ?? 0} left',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (isLoading)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(30, (index) => const ShimmerBlock(width: 24, height: 24, borderRadius: 6.0)),
            )
          else
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(30, (index) {
                final days = dailyStreak?.last30Days ?? List.filled(30, false);
                final isActive = index < days.length ? days[index] : false;
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.amber : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

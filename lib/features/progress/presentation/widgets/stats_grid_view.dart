import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import '../../domain/entities/gamification.dart';
import 'stat_card_widget.dart';

class StatsGridView extends StatelessWidget {
  final bool isLoading;
  final Gamification? gamification;

  const StatsGridView({
    super.key,
    this.isLoading = false,
    this.gamification,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern();
    final exercisesDoneStr = gamification?.exercisesDone != null ? format.format(gamification!.exercisesDone) : '--';
    final accuracyStr = gamification?.accuracy != null ? '${gamification!.accuracy!.toStringAsFixed(0)}%' : '--';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: [
        StatCardWidget(
          title: 'day streak',
          value: gamification?.currentStreak.toString() ?? '0',
          icon: '🔥',
          isLoading: isLoading,
        ),
        StatCardWidget(
          title: 'XP',
          value: format.format(gamification?.xp ?? 0),
          icon: '⚡',
          isLoading: isLoading,
        ),
        StatCardWidget(
          title: 'exercises done',
          value: exercisesDoneStr,
          icon: '📚', 
          isLoading: isLoading,
        ),
        StatCardWidget(
          title: 'accuracy',
          value: accuracyStr,
          icon: '🎯',
          isLoading: isLoading,
        ),
      ],
    );
  }
}

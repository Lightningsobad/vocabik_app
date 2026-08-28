import 'package:equatable/equatable.dart';

class ProgressStreak extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final bool freezeActive;
  final int freezeCount;
  final List<bool> heatmap30Days;

  const ProgressStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.freezeActive,
    required this.freezeCount,
    required this.heatmap30Days,
  });

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        freezeActive,
        freezeCount,
        heatmap30Days,
      ];
}

class ProgressLevel extends Equatable {
  final String level;
  final String currentTitle;
  final String? nextTitle;
  final int currentXpInLevel;
  final int xpRequiredForNextLevel;
  final int totalXp;
  final int progressPct;
  final int remainingXp;

  const ProgressLevel({
    required this.level,
    required this.currentTitle,
    this.nextTitle,
    required this.currentXpInLevel,
    required this.xpRequiredForNextLevel,
    required this.totalXp,
    required this.progressPct,
    required this.remainingXp,
  });

  @override
  List<Object?> get props => [
        level,
        currentTitle,
        nextTitle,
        currentXpInLevel,
        xpRequiredForNextLevel,
        totalXp,
        progressPct,
        remainingXp,
      ];
}

class WeeklyXpItem extends Equatable {
  final String label;
  final int xp;

  const WeeklyXpItem({
    required this.label,
    required this.xp,
  });

  @override
  List<Object?> get props => [label, xp];
}

class ProgressStats extends Equatable {
  final int exercisesCompleted;
  final int? accuracyPct;

  const ProgressStats({
    required this.exercisesCompleted,
    this.accuracyPct,
  });

  @override
  List<Object?> get props => [exercisesCompleted, accuracyPct];
}

class ProgressSummary extends Equatable {
  final ProgressStreak streak;
  final ProgressLevel level;
  final List<WeeklyXpItem> weeklyXp;
  final ProgressStats stats;

  const ProgressSummary({
    required this.streak,
    required this.level,
    required this.weeklyXp,
    required this.stats,
  });

  @override
  List<Object?> get props => [streak, level, weeklyXp, stats];
}

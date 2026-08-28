import '../../domain/entities/progress_summary.dart';

class ProgressStreakModel extends ProgressStreak {
  const ProgressStreakModel({
    required super.currentStreak,
    required super.longestStreak,
    required super.freezeActive,
    required super.freezeCount,
    required super.heatmap30Days,
  });

  factory ProgressStreakModel.fromJson(Map<String, dynamic> json) {
    return ProgressStreakModel(
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      freezeActive: json['freezeActive'] as bool? ?? false,
      freezeCount: json['freezeCount'] as int? ?? 0,
      heatmap30Days: (json['heatmap30Days'] as List<dynamic>?)
              ?.map((e) => e as bool? ?? false)
              .toList() ??
          List.filled(30, false),
    );
  }
}

class ProgressLevelModel extends ProgressLevel {
  const ProgressLevelModel({
    required super.level,
    required super.currentTitle,
    super.nextTitle,
    required super.currentXpInLevel,
    required super.xpRequiredForNextLevel,
    required super.totalXp,
    required super.progressPct,
    required super.remainingXp,
  });

  factory ProgressLevelModel.fromJson(Map<String, dynamic> json) {
    return ProgressLevelModel(
      level: json['level'] as String? ?? 'A1',
      currentTitle: json['currentTitle'] as String? ?? 'Beginner',
      nextTitle: json['nextTitle'] as String?,
      currentXpInLevel: json['currentXpInLevel'] as int? ?? 0,
      xpRequiredForNextLevel: json['xpRequiredForNextLevel'] as int? ?? 500,
      totalXp: json['totalXp'] as int? ?? 0,
      progressPct: json['progressPct'] as int? ?? 0,
      remainingXp: json['remainingXp'] as int? ?? 500,
    );
  }
}

class WeeklyXpItemModel extends WeeklyXpItem {
  const WeeklyXpItemModel({
    required super.label,
    required super.xp,
  });

  factory WeeklyXpItemModel.fromJson(Map<String, dynamic> json) {
    final rawLabel = json['label'] as String? ?? '';
    final formattedLabel = rawLabel.startsWith('T')
        ? 'W${rawLabel.replaceAll('T', '')}'
        : rawLabel;
    return WeeklyXpItemModel(
      label: formattedLabel,
      xp: json['xp'] as int? ?? 0,
    );
  }
}

class ProgressStatsModel extends ProgressStats {
  const ProgressStatsModel({
    required super.exercisesCompleted,
    super.accuracyPct,
  });

  factory ProgressStatsModel.fromJson(Map<String, dynamic> json) {
    return ProgressStatsModel(
      exercisesCompleted: json['exercisesCompleted'] as int? ?? 0,
      accuracyPct: json['accuracyPct'] as int?,
    );
  }
}

class ProgressSummaryModel extends ProgressSummary {
  const ProgressSummaryModel({
    required super.streak,
    required super.level,
    required super.weeklyXp,
    required super.stats,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawWeekly = (json['weeklyXp'] as List<dynamic>?)
            ?.map((e) => WeeklyXpItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final weeklyXp = rawWeekly.isNotEmpty
        ? rawWeekly
        : const [
            WeeklyXpItemModel(label: 'W1', xp: 0),
            WeeklyXpItemModel(label: 'W2', xp: 0),
            WeeklyXpItemModel(label: 'W3', xp: 0),
            WeeklyXpItemModel(label: 'W4', xp: 0),
          ];

    return ProgressSummaryModel(
      streak: ProgressStreakModel.fromJson(
        json['streak'] as Map<String, dynamic>? ?? {},
      ),
      level: ProgressLevelModel.fromJson(
        json['level'] as Map<String, dynamic>? ?? {},
      ),
      weeklyXp: weeklyXp,
      stats: ProgressStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

import '../../domain/entities/gamification.dart';

class GamificationModel extends Gamification {
  const GamificationModel({
    required super.currentStreak,
    required super.xp,
    super.levelInfo,
    required super.streakFreeze,
    super.exercisesDone,
    super.accuracy,
  });

  factory GamificationModel.fromJson(Map<String, dynamic> json) {
    LevelInfo? parsedLevelInfo;
    if (json['levelInfo'] != null) {
      final levelJson = json['levelInfo'] as Map<String, dynamic>;
      parsedLevelInfo = LevelInfo(
        currentLevel: (levelJson['currentLevel'] ?? 'Beginner') as String,
        nextLevel: (levelJson['nextLevel'] ?? 'Intermediate') as String,
        currentXpInLevel: (levelJson['currentXpInLevel'] ?? 0) as int,
        maxXpInLevel: (levelJson['maxXpInLevel'] ?? 100) as int,
      );
    }

    return GamificationModel(
      currentStreak: (json['currentStreak'] ?? 0) as int,
      xp: (json['xp'] ?? 0) as int,
      levelInfo: parsedLevelInfo,
      streakFreeze: (json['streakFreeze'] ?? 0) as int,
      exercisesDone: json['exercisesDone'] as int?,
      accuracy: (json['accuracy'] != null) ? (json['accuracy'] as num).toDouble() : null,
    );
  }
}

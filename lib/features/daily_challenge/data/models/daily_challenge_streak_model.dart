import '../../domain/entities/daily_challenge_streak_entity.dart';

class DailyChallengeStreakModel extends DailyChallengeStreakEntity {
  const DailyChallengeStreakModel({
    required super.userId,
    required super.currentStreak,
    required super.longestStreak,
    super.lastParticipationDate,
    super.updatedAt,
  });

  factory DailyChallengeStreakModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeStreakModel(
      userId: json['userId'] as String? ?? '',
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastParticipationDate: json['lastParticipationDate'] != null
          ? DateTime.tryParse(json['lastParticipationDate'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastParticipationDate': lastParticipationDate?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

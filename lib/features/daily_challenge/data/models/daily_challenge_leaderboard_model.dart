import '../../domain/entities/daily_challenge_leaderboard_entity.dart';

class DailyChallengeLeaderboardItemModel
    extends DailyChallengeLeaderboardItemEntity {
  const DailyChallengeLeaderboardItemModel({
    required super.rank,
    required super.userId,
    required super.userName,
    super.avatarUrl,
    super.scoreAccuracy = 0,
    super.scoreTimeMs = 0,
    super.isCurrentUser = false,
  });

  factory DailyChallengeLeaderboardItemModel.fromJson(
    Map<String, dynamic> json, {
    int defaultRank = 1,
  }) {
    return DailyChallengeLeaderboardItemModel(
      rank: (json['rank'] as num?)?.toInt() ?? defaultRank,
      userId: json['userId'] as String? ?? '',
      userName: json['displayName'] as String? ?? 'User',
      avatarUrl: json['avatarUrl'] as String?,
      scoreAccuracy: (json['scoreAccuracy'] as num?)?.toInt() ?? 0,
      scoreTimeMs: (json['scoreTimeMs'] as num?)?.toInt() ?? 0,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'displayName': userName,
      'avatarUrl': avatarUrl,
      'scoreAccuracy': scoreAccuracy,
      'scoreTimeMs': scoreTimeMs,
      'isCurrentUser': isCurrentUser,
    };
  }
}




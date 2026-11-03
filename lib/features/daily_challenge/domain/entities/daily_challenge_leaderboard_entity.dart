import 'package:equatable/equatable.dart';

class DailyChallengeLeaderboardItemEntity extends Equatable {
  final int rank;
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int scoreAccuracy;
  final int scoreTimeMs;
  final bool isCurrentUser;

  const DailyChallengeLeaderboardItemEntity({
    required this.rank,
    required this.userId,
    required this.userName,
    this.avatarUrl,
    this.scoreAccuracy = 0,
    this.scoreTimeMs = 0,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
        rank,
        userId,
        userName,
        avatarUrl,
        scoreAccuracy,
        scoreTimeMs,
        isCurrentUser,
      ];
}



import 'package:equatable/equatable.dart';

import '../../domain/entities/daily_challenge_config_entity.dart';
import '../../domain/entities/daily_challenge_leaderboard_entity.dart';
import '../../domain/entities/daily_challenge_streak_entity.dart';

abstract class DailyChallengeState extends Equatable {
  const DailyChallengeState();

  @override
  List<Object?> get props => [];
}

class DailyChallengeInitial extends DailyChallengeState {
  const DailyChallengeInitial();
}

class DailyChallengeLoading extends DailyChallengeState {
  final DailyChallengeResponseEntity? cachedConfig;

  const DailyChallengeLoading({this.cachedConfig});

  @override
  List<Object?> get props => [cachedConfig];
}

class DailyChallengeLoaded extends DailyChallengeState {
  final DailyChallengeResponseEntity configResponse;
  final List<DailyChallengeLeaderboardItemEntity> leaderboard;
  final DailyChallengeStreakEntity? streak;

  const DailyChallengeLoaded({
    required this.configResponse,
    required this.leaderboard,
    this.streak,
  });

  @override
  List<Object?> get props => [configResponse, leaderboard, streak];
}

class DailyChallengeError extends DailyChallengeState {
  final String message;
  final DailyChallengeResponseEntity? cachedConfig;

  const DailyChallengeError(this.message, {this.cachedConfig});

  @override
  List<Object?> get props => [message, cachedConfig];
}

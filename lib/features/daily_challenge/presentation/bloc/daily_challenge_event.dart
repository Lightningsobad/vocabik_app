import 'package:equatable/equatable.dart';

import '../../domain/entities/daily_challenge_config_entity.dart';

abstract class DailyChallengeEvent extends Equatable {
  const DailyChallengeEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyChallenge extends DailyChallengeEvent {
  final DailyChallengeResponseEntity? initialConfig;

  const LoadDailyChallenge({this.initialConfig});

  @override
  List<Object?> get props => [initialConfig];
}

class RefreshDailyChallenge extends DailyChallengeEvent {
  const RefreshDailyChallenge();
}

import 'package:equatable/equatable.dart';

import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_config_entity.dart';

abstract class HomeDailyChallengeState extends Equatable {
  const HomeDailyChallengeState();

  @override
  List<Object?> get props => [];
}

class HomeDailyChallengeInitial extends HomeDailyChallengeState {
  const HomeDailyChallengeInitial();
}

class HomeDailyChallengeLoading extends HomeDailyChallengeState {
  const HomeDailyChallengeLoading();
}

class HomeDailyChallengeLoaded extends HomeDailyChallengeState {
  final DailyChallengeResponseEntity response;

  const HomeDailyChallengeLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class HomeDailyChallengeError extends HomeDailyChallengeState {
  final String message;

  const HomeDailyChallengeError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class HomeDailyChallengeEvent extends Equatable {
  const HomeDailyChallengeEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeDailyChallenge extends HomeDailyChallengeEvent {
  const FetchHomeDailyChallenge();
}

class RefreshHomeDailyChallenge extends HomeDailyChallengeEvent {
  const RefreshHomeDailyChallenge();
}

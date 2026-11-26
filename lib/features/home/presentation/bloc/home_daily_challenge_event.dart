import 'dart:async';

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
  final Completer<void>? completer;

  const RefreshHomeDailyChallenge({this.completer});

  @override
  List<Object?> get props => [completer];
}

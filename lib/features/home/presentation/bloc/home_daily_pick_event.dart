import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class HomeDailyPickEvent extends Equatable {
  const HomeDailyPickEvent();

  @override
  List<Object?> get props => [];
}

class FetchDailyPick extends HomeDailyPickEvent {
  const FetchDailyPick();
}

class RefreshDailyPick extends HomeDailyPickEvent {
  final Completer<void>? completer;

  const RefreshDailyPick({this.completer});

  @override
  List<Object?> get props => [completer];
}

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
  const RefreshDailyPick();
}

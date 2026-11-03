import 'package:equatable/equatable.dart';

abstract class HomePersonalizedEvent extends Equatable {
  const HomePersonalizedEvent();

  @override
  List<Object?> get props => [];
}

class FetchPersonalizedSlots extends HomePersonalizedEvent {
  const FetchPersonalizedSlots();
}

class RefreshPersonalizedSlots extends HomePersonalizedEvent {
  const RefreshPersonalizedSlots();
}

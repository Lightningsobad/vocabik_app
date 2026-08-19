import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';

abstract class HomePersonalizedState extends Equatable {
  const HomePersonalizedState();

  @override
  List<Object?> get props => [];
}

class HomePersonalizedInitial extends HomePersonalizedState {}

class HomePersonalizedLoading extends HomePersonalizedState {}

class HomePersonalizedLoaded extends HomePersonalizedState {
  final List<PersonalizedSlotEntity> slots;

  const HomePersonalizedLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class HomePersonalizedError extends HomePersonalizedState {
  final String message;

  const HomePersonalizedError(this.message);

  @override
  List<Object?> get props => [message];
}

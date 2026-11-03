import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';

abstract class HomeDailyPickState extends Equatable {
  const HomeDailyPickState();

  @override
  List<Object?> get props => [];
}

class HomeDailyPickInitial extends HomeDailyPickState {}

class HomeDailyPickLoading extends HomeDailyPickState {}

class HomeDailyPickLoaded extends HomeDailyPickState {
  final DailyPickEntity dailyPick;

  const HomeDailyPickLoaded(this.dailyPick);

  @override
  List<Object?> get props => [dailyPick];
}

class HomeDailyPickError extends HomeDailyPickState {
  final String message;

  const HomeDailyPickError(this.message);

  @override
  List<Object?> get props => [message];
}

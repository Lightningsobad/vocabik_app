import 'package:equatable/equatable.dart';
import '../../domain/entities/leaderboard_response_entity.dart';

abstract class XpLeaderboardState extends Equatable {
  const XpLeaderboardState();

  @override
  List<Object?> get props => [];
}

class XpLeaderboardInitial extends XpLeaderboardState {
  const XpLeaderboardInitial();
}

class XpLeaderboardLoading extends XpLeaderboardState {
  final String selectedPeriod;
  final String selectedScope;
  final LeaderboardResponseEntity? cachedData;

  const XpLeaderboardLoading({
    this.selectedPeriod = 'this_week',
    this.selectedScope = 'global',
    this.cachedData,
  });

  @override
  List<Object?> get props => [selectedPeriod, selectedScope, cachedData];
}

class XpLeaderboardLoaded extends XpLeaderboardState {
  final LeaderboardResponseEntity data;
  final String selectedPeriod;
  final String selectedScope;

  const XpLeaderboardLoaded({
    required this.data,
    required this.selectedPeriod,
    required this.selectedScope,
  });

  @override
  List<Object?> get props => [data, selectedPeriod, selectedScope];
}

class XpLeaderboardError extends XpLeaderboardState {
  final String message;
  final String selectedPeriod;
  final String selectedScope;
  final LeaderboardResponseEntity? cachedData;

  const XpLeaderboardError({
    required this.message,
    this.selectedPeriod = 'this_week',
    this.selectedScope = 'global',
    this.cachedData,
  });

  @override
  List<Object?> get props => [message, selectedPeriod, selectedScope, cachedData];
}

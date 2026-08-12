part of 'gamification_global_cubit.dart';

class GamificationGlobalState extends Equatable {
  final int streak;
  final int xp;

  const GamificationGlobalState({
    this.streak = 0,
    this.xp = 0,
  });

  GamificationGlobalState copyWith({
    int? streak,
    int? xp,
  }) {
    return GamificationGlobalState(
      streak: streak ?? this.streak,
      xp: xp ?? this.xp,
    );
  }

  @override
  List<Object> get props => [streak, xp];
}

part of 'gamification_global_cubit.dart';

class GamificationGlobalState extends Equatable {
  final int streak;
  final int xp;
  final bool isLoading;

  const GamificationGlobalState({
    this.streak = 0,
    this.xp = 0,
    this.isLoading = false,
  });

  GamificationGlobalState copyWith({
    int? streak,
    int? xp,
    bool? isLoading,
  }) {
    return GamificationGlobalState(
      streak: streak ?? this.streak,
      xp: xp ?? this.xp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [streak, xp, isLoading];
}

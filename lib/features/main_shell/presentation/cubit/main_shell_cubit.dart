import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../progress/domain/entities/progress_summary.dart';
import '../../../progress/domain/use_cases/get_progress_summary_use_case.dart';
import '../../../../shared/gamification/cubit/gamification_global_cubit.dart';

part 'main_shell_state.dart';

@lazySingleton
class MainShellCubit extends Cubit<MainShellState> {
  final GetProgressSummaryUseCase _getProgressSummaryUseCase;
  final GamificationGlobalCubit _gamificationGlobalCubit;

  MainShellCubit(
    this._getProgressSummaryUseCase,
    this._gamificationGlobalCubit,
  ) : super(const MainShellState());

  Future<void> loadSummary() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    _gamificationGlobalCubit.setLoading(true);

    final result = await _getProgressSummaryUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
        _gamificationGlobalCubit.setLoading(false);
      },
      (summary) {
        emit(state.copyWith(isLoading: false, summary: summary));
        _gamificationGlobalCubit.updateStats(
          streak: summary.streak.currentStreak,
          xp: summary.level.totalXp,
        );
      },
    );
  }
}

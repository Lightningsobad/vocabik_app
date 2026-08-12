import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/use_cases/get_gamification_summary_use_case.dart';

import '../../../../shared/gamification/cubit/gamification_global_cubit.dart';

part 'progress_state.dart';

@injectable
class ProgressCubit extends Cubit<ProgressState> {
  final GetGamificationSummaryUseCase _getGamificationSummaryUseCase;
  final GamificationGlobalCubit _gamificationGlobalCubit;

  ProgressCubit(
    this._getGamificationSummaryUseCase,
    this._gamificationGlobalCubit,
  ) : super(ProgressInitial());

  Future<void> loadProgressData() async {
    emit(ProgressLoading());
    final result = await _getGamificationSummaryUseCase();
    result.fold(
      (failure) => emit(ProgressError(failure.message)),
      (summary) {
        emit(ProgressLoaded(summary));
        _gamificationGlobalCubit.updateStats(
          streak: summary.gamification.currentStreak,
          xp: summary.gamification.xp,
        );
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/progress_summary.dart';
import '../../domain/entities/progress_history.dart';
import '../../domain/entities/progress_error_insights.dart';
import '../../domain/use_cases/get_progress_summary_use_case.dart';
import '../../domain/use_cases/get_progress_history_use_case.dart';
import '../../domain/use_cases/get_progress_error_insights_use_case.dart';
import '../../../../shared/gamification/cubit/gamification_global_cubit.dart';

part 'progress_state.dart';

@injectable
class ProgressCubit extends Cubit<ProgressState> {
  final GetProgressSummaryUseCase _getProgressSummaryUseCase;
  final GetProgressHistoryUseCase _getProgressHistoryUseCase;
  final GetProgressErrorInsightsUseCase _getProgressErrorInsightsUseCase;
  final GamificationGlobalCubit _gamificationGlobalCubit;

  ProgressCubit(
    this._getProgressSummaryUseCase,
    this._getProgressHistoryUseCase,
    this._getProgressErrorInsightsUseCase,
    this._gamificationGlobalCubit,
  ) : super(ProgressInitial());

  Future<void> loadProgressData() async {
    emit(ProgressLoading());

    final results = await Future.wait([
      _getProgressSummaryUseCase(),
      _getProgressHistoryUseCase(),
      _getProgressErrorInsightsUseCase(),
    ]);

    final summaryResult = results[0];
    final historyResult = results[1];
    final errorInsightsResult = results[2];

    summaryResult.fold(
      (failure) => emit(ProgressError(failure.message)),
      (summaryData) {
        final summary = summaryData as ProgressSummary;

        ProgressHistory? history;
        historyResult.fold(
          (_) => null,
          (data) => history = data as ProgressHistory?,
        );

        ProgressErrorInsights? errorInsights;
        errorInsightsResult.fold(
          (_) => null,
          (data) => errorInsights = data as ProgressErrorInsights?,
        );

        emit(ProgressLoaded(
          summary: summary,
          history: history,
          errorInsights: errorInsights,
        ));

        _gamificationGlobalCubit.updateStats(
          streak: summary.streak.currentStreak,
          xp: summary.level.totalXp,
        );
      },
    );
  }
}

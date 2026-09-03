import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/progress_history.dart';
import '../../domain/entities/progress_error_insights.dart';
import '../../domain/use_cases/get_progress_history_use_case.dart';
import '../../domain/use_cases/get_progress_error_insights_use_case.dart';

part 'progress_state.dart';

@injectable
class ProgressCubit extends Cubit<ProgressState> {
  final GetProgressHistoryUseCase _getProgressHistoryUseCase;
  final GetProgressErrorInsightsUseCase _getProgressErrorInsightsUseCase;

  ProgressCubit(
    this._getProgressHistoryUseCase,
    this._getProgressErrorInsightsUseCase,
  ) : super(ProgressInitial());

  Future<void> loadProgressData() async {
    emit(ProgressLoading());

    try {
      final results = await Future.wait([
        _getProgressHistoryUseCase(),
        _getProgressErrorInsightsUseCase(),
      ]);

      final historyResult = results[0];
      final errorInsightsResult = results[1];

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
        history: history,
        errorInsights: errorInsights,
      ));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}


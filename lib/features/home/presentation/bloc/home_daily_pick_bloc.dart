import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/bloc/droppable_completer.dart';
import 'package:vocabik_app/features/home/domain/usecases/get_daily_pick_usecase.dart';

import 'home_daily_pick_event.dart';
import 'home_daily_pick_state.dart';

@injectable
class HomeDailyPickBloc extends Bloc<HomeDailyPickEvent, HomeDailyPickState> {
  final GetDailyPickUseCase getDailyPickUseCase;

  HomeDailyPickBloc(this.getDailyPickUseCase) : super(HomeDailyPickInitial()) {
    on<FetchDailyPick>(
      _onFetchDailyPick,
      transformer: droppable(),
    );
    on<RefreshDailyPick>(
      _onRefreshDailyPick,
      transformer: droppableCompleter((e) => e.completer),
    );
  }

  Future<void> _onFetchDailyPick(
    FetchDailyPick event,
    Emitter<HomeDailyPickState> emit,
  ) async {
    final cached = getDailyPickUseCase.getCached();
    if (cached != null) {
      emit(HomeDailyPickLoaded(cached));
      return;
    }

    emit(HomeDailyPickLoading());

    final result = await getDailyPickUseCase();
    result.fold(
      (failure) => emit(HomeDailyPickError(failure.message)),
      (dailyPick) => emit(HomeDailyPickLoaded(dailyPick)),
    );
  }

  Future<void> _onRefreshDailyPick(
    RefreshDailyPick event,
    Emitter<HomeDailyPickState> emit,
  ) async {
    try {
      final result = await getDailyPickUseCase(forceRefresh: true);
      result.fold(
        (failure) {
          if (state is! HomeDailyPickLoaded) {
            emit(HomeDailyPickError(failure.message));
          }
        },
        (dailyPick) => emit(HomeDailyPickLoaded(dailyPick)),
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
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
      transformer: droppable(),
    );
  }

  Future<void> _onFetchDailyPick(
    FetchDailyPick event,
    Emitter<HomeDailyPickState> emit,
  ) async {
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
    final result = await getDailyPickUseCase();
    result.fold(
      (failure) => emit(HomeDailyPickError(failure.message)),
      (dailyPick) => emit(HomeDailyPickLoaded(dailyPick)),
    );
  }
}

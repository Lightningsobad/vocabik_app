import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/bloc/droppable_completer.dart';
import 'package:vocabik_app/features/daily_challenge/domain/usecases/get_daily_challenge_config_usecase.dart';

import 'home_daily_challenge_event.dart';
import 'home_daily_challenge_state.dart';

@injectable
class HomeDailyChallengeBloc
    extends Bloc<HomeDailyChallengeEvent, HomeDailyChallengeState> {
  final GetDailyChallengeConfigUseCase _getConfigUseCase;

  HomeDailyChallengeBloc(this._getConfigUseCase)
      : super(const HomeDailyChallengeInitial()) {
    on<FetchHomeDailyChallenge>(_onFetch, transformer: droppable());
    on<RefreshHomeDailyChallenge>(
      _onRefresh,
      transformer: droppableCompleter((e) => e.completer),
    );
  }

  Future<void> _onFetch(
    FetchHomeDailyChallenge event,
    Emitter<HomeDailyChallengeState> emit,
  ) async {
    final cached = _getConfigUseCase.getCached();
    if (cached != null) {
      emit(HomeDailyChallengeLoaded(cached));
    } else {
      emit(const HomeDailyChallengeLoading());
    }

    final result = await _getConfigUseCase(forceRefresh: cached != null);
    result.fold(
      (failure) {
        if (state is! HomeDailyChallengeLoaded) {
          emit(HomeDailyChallengeError(failure.message));
        }
      },
      (response) => emit(HomeDailyChallengeLoaded(response)),
    );
  }

  Future<void> _onRefresh(
    RefreshHomeDailyChallenge event,
    Emitter<HomeDailyChallengeState> emit,
  ) async {
    try {
      final result = await _getConfigUseCase(forceRefresh: true);
      result.fold(
        (failure) {
          if (state is! HomeDailyChallengeLoaded) {
            emit(HomeDailyChallengeError(failure.message));
          }
        },
        (response) => emit(HomeDailyChallengeLoaded(response)),
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }
}

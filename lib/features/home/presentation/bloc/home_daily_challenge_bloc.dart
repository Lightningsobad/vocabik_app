import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:vocabik_app/features/daily_challenge/domain/usecases/get_daily_challenge_config_usecase.dart';
import 'home_daily_challenge_event.dart';
import 'home_daily_challenge_state.dart';

@injectable
class HomeDailyChallengeBloc
    extends Bloc<HomeDailyChallengeEvent, HomeDailyChallengeState> {
  final GetDailyChallengeConfigUseCase _getConfigUseCase;

  HomeDailyChallengeBloc(this._getConfigUseCase)
      : super(const HomeDailyChallengeInitial()) {
    on<FetchHomeDailyChallenge>(_onFetch);
    on<RefreshHomeDailyChallenge>(_onRefresh);
  }

  Future<void> _onFetch(
    FetchHomeDailyChallenge event,
    Emitter<HomeDailyChallengeState> emit,
  ) async {
    emit(const HomeDailyChallengeLoading());
    final result = await _getConfigUseCase();
    result.fold(
      (failure) => emit(HomeDailyChallengeError(failure.message)),
      (response) => emit(HomeDailyChallengeLoaded(response)),
    );
  }

  Future<void> _onRefresh(
    RefreshHomeDailyChallenge event,
    Emitter<HomeDailyChallengeState> emit,
  ) async {
    final result = await _getConfigUseCase();
    result.fold(
      (failure) => emit(HomeDailyChallengeError(failure.message)),
      (response) => emit(HomeDailyChallengeLoaded(response)),
    );
  }
}

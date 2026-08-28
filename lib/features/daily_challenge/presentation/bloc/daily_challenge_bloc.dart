import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/daily_challenge_config_entity.dart';
import '../../domain/entities/daily_challenge_leaderboard_entity.dart';
import '../../domain/entities/daily_challenge_streak_entity.dart';
import '../../domain/usecases/get_daily_challenge_config_usecase.dart';
import '../../domain/usecases/get_daily_challenge_leaderboard_usecase.dart';
import '../../domain/usecases/get_daily_challenge_streak_usecase.dart';
import 'daily_challenge_event.dart';
import 'daily_challenge_state.dart';

@injectable
class DailyChallengeBloc
    extends Bloc<DailyChallengeEvent, DailyChallengeState> {
  final GetDailyChallengeConfigUseCase _getConfigUseCase;
  final GetDailyChallengeLeaderboardUseCase _getLeaderboardUseCase;
  final GetDailyChallengeStreakUseCase _getStreakUseCase;

  DailyChallengeResponseEntity? _currentConfig;

  DailyChallengeBloc(
    this._getConfigUseCase,
    this._getLeaderboardUseCase,
    this._getStreakUseCase,
  ) : super(const DailyChallengeInitial()) {
    on<LoadDailyChallenge>(_onLoad);
    on<RefreshDailyChallenge>(_onRefresh);
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _onLoad(
    LoadDailyChallenge event,
    Emitter<DailyChallengeState> emit,
  ) async {
    _currentConfig = event.initialConfig ?? _currentConfig;

    emit(DailyChallengeLoading(cachedConfig: _currentConfig));

    DailyChallengeResponseEntity? config = _currentConfig;
    if (config == null) {
      final configResult = await _getConfigUseCase();
      config = configResult.fold(
        (failure) => null,
        (data) => data,
      );
    }

    if (config == null) {
      emit(const DailyChallengeError('Failed to load daily challenge config'));
      return;
    }
    _currentConfig = config;

    final dateStr = config.config?.challengeDate.isNotEmpty == true
        ? config.config!.challengeDate
        : _formatDate(DateTime.now());

    final results = await Future.wait([
      _getLeaderboardUseCase(dateStr),
      _getStreakUseCase(),
    ]);

    final leaderboardResult = results[0];
    final streakResult = results[1];

    List<DailyChallengeLeaderboardItemEntity> leaderboard = [];
    DailyChallengeStreakEntity? streak;

    leaderboardResult.fold(
      (failure) => null,
      (data) => leaderboard = data as List<DailyChallengeLeaderboardItemEntity>,
    );

    streakResult.fold(
      (failure) => null,
      (data) => streak = data as DailyChallengeStreakEntity,
    );

    emit(DailyChallengeLoaded(
      configResponse: config,
      leaderboard: leaderboard,
      streak: streak,
    ));
  }

  Future<void> _onRefresh(
    RefreshDailyChallenge event,
    Emitter<DailyChallengeState> emit,
  ) async {
    final configResult = await _getConfigUseCase();
    final config = configResult.fold(
      (failure) => _currentConfig,
      (data) => data,
    );

    if (config == null) {
      emit(const DailyChallengeError('Failed to refresh daily challenge'));
      return;
    }
    _currentConfig = config;

    final dateStr = config.config?.challengeDate.isNotEmpty == true
        ? config.config!.challengeDate
        : _formatDate(DateTime.now());

    final results = await Future.wait([
      _getLeaderboardUseCase(dateStr),
      _getStreakUseCase(),
    ]);

    List<DailyChallengeLeaderboardItemEntity> leaderboard = [];
    DailyChallengeStreakEntity? streak;

    results[0].fold(
      (failure) => null,
      (data) => leaderboard = data as List<DailyChallengeLeaderboardItemEntity>,
    );

    results[1].fold(
      (failure) => null,
      (data) => streak = data as DailyChallengeStreakEntity,
    );

    emit(DailyChallengeLoaded(
      configResponse: config,
      leaderboard: leaderboard,
      streak: streak,
    ));
  }
}

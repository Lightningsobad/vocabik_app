import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/use_cases/get_xp_leaderboard_use_case.dart';
import 'xp_leaderboard_state.dart';

@injectable
class XpLeaderboardCubit extends Cubit<XpLeaderboardState> {
  final GetXpLeaderboardUseCase _getXpLeaderboardUseCase;

  XpLeaderboardCubit(this._getXpLeaderboardUseCase)
      : super(const XpLeaderboardInitial());

  String _currentPeriod = 'this_week';
  String _currentScope = 'global';

  String get currentPeriod => _currentPeriod;
  String get currentScope => _currentScope;

  Future<void> loadLeaderboard({
    String? period,
    String? scope,
    bool isRefresh = false,
  }) async {
    if (period != null) _currentPeriod = period;
    if (scope != null) _currentScope = scope;

    final cachedData = state is XpLeaderboardLoaded
        ? (state as XpLeaderboardLoaded).data
        : (state is XpLeaderboardLoading
            ? (state as XpLeaderboardLoading).cachedData
            : null);

    if (!isRefresh) {
      emit(XpLeaderboardLoading(
        selectedPeriod: _currentPeriod,
        selectedScope: _currentScope,
        cachedData: cachedData,
      ));
    }

    final result = await _getXpLeaderboardUseCase(
      period: _currentPeriod,
      scope: _currentScope,
    );

    result.fold(
      (failure) {
        emit(XpLeaderboardError(
          message: failure.message,
          selectedPeriod: _currentPeriod,
          selectedScope: _currentScope,
          cachedData: cachedData,
        ));
      },
      (data) {
        emit(XpLeaderboardLoaded(
          data: data,
          selectedPeriod: _currentPeriod,
          selectedScope: _currentScope,
        ));
      },
    );
  }
}

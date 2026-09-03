import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/get_sessions_use_case.dart';

import 'active_sessions_state.dart';

@injectable
class ActiveSessionsCubit extends Cubit<ActiveSessionsState> {
  final GetSessionsUseCase _getSessionsUseCase;

  ActiveSessionsCubit(this._getSessionsUseCase)
      : super(const ActiveSessionsState());

  Future<void> loadSessions() async {
    emit(state.copyWith(status: ActiveSessionsStatus.loading));

    final result = await _getSessionsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ActiveSessionsStatus.failure,
        errorMessage: failure.message,
      )),
      (sessions) {
        final sortedSessions = List<UserSession>.from(sessions)
          ..sort((a, b) {
            if (a.current != b.current) {
              return a.current ? -1 : 1;
            }
            final aTime = a.lastActive ?? a.createdAt;
            final bTime = b.lastActive ?? b.createdAt;
            if (aTime != null && bTime != null) {
              return bTime.compareTo(aTime);
            } else if (aTime != null) {
              return -1;
            } else if (bTime != null) {
              return 1;
            }
            return 0;
          });

        emit(state.copyWith(
          status: ActiveSessionsStatus.success,
          sessions: sortedSessions,
        ));
      },
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';

enum ActiveSessionsStatus { initial, loading, success, failure }

class ActiveSessionsState extends Equatable {
  final ActiveSessionsStatus status;
  final List<UserSession> sessions;
  final String? errorMessage;

  const ActiveSessionsState({
    this.status = ActiveSessionsStatus.initial,
    this.sessions = const [],
    this.errorMessage,
  });

  ActiveSessionsState copyWith({
    ActiveSessionsStatus? status,
    List<UserSession>? sessions,
    String? errorMessage,
  }) {
    return ActiveSessionsState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sessions, errorMessage];
}

part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  final AuthStatus status;
  final String? errorMessage;
  final User? user;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user];
}

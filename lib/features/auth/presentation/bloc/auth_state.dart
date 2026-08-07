part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.errorMessage,
    this.user,
  });

  final AuthStatus status;
  final EmailInput email;
  final PasswordInput password;
  final String? errorMessage;
  final User? user;

  AuthState copyWith({
    AuthStatus? status,
    EmailInput? email,
    PasswordInput? password,
    String? errorMessage,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, email, password, errorMessage, user];
}

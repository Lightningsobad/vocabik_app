import 'package:equatable/equatable.dart';
import '../models/email_input.dart';
import '../models/password_input.dart';

enum LoginStatus { initial, loading, success, failure, unverified }

class LoginState extends Equatable {
  final EmailInput email;
  final PasswordInput password;
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    EmailInput? email,
    PasswordInput? password,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];
}

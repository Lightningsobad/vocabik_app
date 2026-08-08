import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../models/email_input.dart';
import '../models/password_input.dart';
import '../models/display_name_input.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final DisplayNameInput displayName;
  final EmailInput email;
  final PasswordInput password;
  final FormzSubmissionStatus formStatus;
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({
    this.displayName = const DisplayNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.status = RegisterStatus.initial,
    this.errorMessage,
  });

  RegisterState copyWith({
    DisplayNameInput? displayName,
    EmailInput? email,
    PasswordInput? password,
    FormzSubmissionStatus? formStatus,
    RegisterStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        email,
        password,
        formStatus,
        status,
        errorMessage,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../models/email_input.dart';
import '../models/password_input.dart';
import '../models/display_name_input.dart';
import '../widgets/password_strength_indicator.dart';

enum RegisterStatus { initial, loading, success, socialSuccess, failure }


class RegisterState extends Equatable {
  final DisplayNameInput displayName;
  final EmailInput email;
  final PasswordInput password;
  final FormzSubmissionStatus formStatus;
  final RegisterStatus status;
  final PasswordStrength passwordStrength;
  final String? errorMessage;

  const RegisterState({
    this.displayName = const DisplayNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.status = RegisterStatus.initial,
    this.passwordStrength = PasswordStrength.none,
    this.errorMessage,
  });

  RegisterState copyWith({
    DisplayNameInput? displayName,
    EmailInput? email,
    PasswordInput? password,
    FormzSubmissionStatus? formStatus,
    RegisterStatus? status,
    PasswordStrength? passwordStrength,
    String? errorMessage,
  }) {
    return RegisterState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      status: status ?? this.status,
      passwordStrength: passwordStrength ?? this.passwordStrength,
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
        passwordStrength,
        errorMessage,
      ];
}

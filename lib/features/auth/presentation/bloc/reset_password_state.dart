import 'package:equatable/equatable.dart';
import '../models/password_input.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState extends Equatable {
  final PasswordInput newPassword;
  final PasswordInput confirmPassword;
  final bool isPasswordMatch;
  final ResetPasswordStatus status;
  final String? errorMessage;
  final String? successMessage;

  const ResetPasswordState({
    this.newPassword = const PasswordInput.pure(),
    this.confirmPassword = const PasswordInput.pure(),
    this.isPasswordMatch = true,
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  ResetPasswordState copyWith({
    PasswordInput? newPassword,
    PasswordInput? confirmPassword,
    bool? isPasswordMatch,
    ResetPasswordStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordMatch: isPasswordMatch ?? this.isPasswordMatch,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        newPassword,
        confirmPassword,
        isPasswordMatch,
        status,
        errorMessage,
        successMessage,
      ];
}

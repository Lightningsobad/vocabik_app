import 'package:equatable/equatable.dart';
import '../models/email_input.dart';

enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  final EmailInput email;
  final ForgotPasswordStatus status;
  final String? errorMessage;
  final String? successMessage;

  const ForgotPasswordState({
    this.email = const EmailInput.pure(),
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  ForgotPasswordState copyWith({
    EmailInput? email,
    ForgotPasswordStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage, successMessage];
}

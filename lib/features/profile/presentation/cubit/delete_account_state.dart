import 'package:equatable/equatable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

enum DeleteAccountStatus { initial, loading, success, failure }

class DeleteAccountState extends Equatable {
  final DeleteAccountStatus status;
  final Failure? failure;
  final String? errorMessage;

  const DeleteAccountState({
    this.status = DeleteAccountStatus.initial,
    this.failure,
    this.errorMessage,
  });

  bool get isPasswordRequired => failure is PasswordRequiredFailure;
  bool get isInvalidPassword => failure is InvalidPasswordFailure;

  DeleteAccountState copyWith({
    DeleteAccountStatus? status,
    Failure? failure,
    String? errorMessage,
  }) {
    return DeleteAccountState(
      status: status ?? this.status,
      failure: failure,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, failure, errorMessage];
}

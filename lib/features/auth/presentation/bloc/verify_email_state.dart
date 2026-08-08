import 'package:equatable/equatable.dart';

enum VerifyEmailStatus { initial, loading, success, failure }

class VerifyEmailState extends Equatable {
  final VerifyEmailStatus status;
  final String? errorMessage;
  final int countdown;

  const VerifyEmailState({
    this.status = VerifyEmailStatus.initial,
    this.errorMessage,
    this.countdown = 0,
  });

  VerifyEmailState copyWith({
    VerifyEmailStatus? status,
    String? errorMessage,
    int? countdown,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      countdown: countdown ?? this.countdown,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, countdown];
}

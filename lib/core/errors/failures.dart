import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class NotVerifiedFailure extends Failure {
  const NotVerifiedFailure([super.message = 'Account not verified']);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message = 'Invalid email or password']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure([super.message = 'User already exists']);
}

class InvalidTokenFailure extends Failure {
  const InvalidTokenFailure([super.message = 'Invalid token']);
}

class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Request cancelled']);
}

class PasswordRequiredFailure extends Failure {
  const PasswordRequiredFailure([super.message = 'Password is required']);
}

class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure([super.message = 'Incorrect password']);
}


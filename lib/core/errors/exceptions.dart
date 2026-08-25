class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error occurred']);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}

class NotVerifiedException implements Exception {
  final String message;
  const NotVerifiedException([this.message = 'Account not verified']);

  @override
  String toString() => 'NotVerifiedException: $message';
}

class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException([this.message = 'Invalid credentials']);

  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

class UserAlreadyExistsException implements Exception {
  final String message;
  const UserAlreadyExistsException([this.message = 'User already exists']);

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}

class InvalidTokenException implements Exception {
  final String message;
  const InvalidTokenException([this.message = 'Invalid token']);

  @override
  String toString() => 'InvalidTokenException: $message';
}

class RequestCancelledException implements Exception {
  final String message;
  const RequestCancelledException([this.message = 'Request cancelled']);

  @override
  String toString() => 'RequestCancelledException: $message';
}


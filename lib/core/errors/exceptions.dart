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

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/auth/domain/entities/user.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/login_with_google_use_case.dart';

class MockAuthRepository implements AuthRepository {
  User? mockUser;
  Failure? mockFailure;
  String? capturedIdToken;
  String? capturedAnonymousSessionId;

  @override
  Future<Either<Failure, User>> loginWithGoogle(
    String idToken, {
    String? anonymousSessionId,
  }) async {
    capturedIdToken = idToken;
    capturedAnonymousSessionId = anonymousSessionId;
    if (mockFailure != null) {
      return left(mockFailure!);
    }
    return right(
      mockUser ??
          const User(
            id: '123',
            email: 'test@gmail.com',
            displayName: 'Test User',
            tier: 'free',
            emailVerified: true,
          ),
    );
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, User>> getMe() => throw UnimplementedError();

  @override
  Future<Either<Failure, List<UserSession>>> getSessions() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String displayName,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> resendVerificationEmail(String email) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> setCefrSkipped(bool value) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> signOut() => throw UnimplementedError();

  @override
  Future<Either<Failure, User>> verifyEmail(String token) =>
      throw UnimplementedError();
}

void main() {
  late LoginWithGoogleUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginWithGoogleUseCase(repository);
  });

  test('should return User when loginWithGoogle succeeds', () async {
    const testUser = User(
      id: 'google_user_1',
      email: 'google@gmail.com',
      displayName: 'Google User',
      tier: 'free',
      emailVerified: true,
    );
    repository.mockUser = testUser;

    final result = await useCase(
      idToken: 'valid_id_token',
      anonymousSessionId: 'anon_123',
    );

    expect(result, const Right(testUser));
    expect(repository.capturedIdToken, 'valid_id_token');
    expect(repository.capturedAnonymousSessionId, 'anon_123');
  });

  test('should return Failure when loginWithGoogle fails', () async {
    repository.mockFailure = const InvalidCredentialsFailure('Invalid token');

    final result = await useCase(idToken: 'invalid_id_token');

    expect(
      result,
      const Left(InvalidCredentialsFailure('Invalid token')),
    );
  });
}

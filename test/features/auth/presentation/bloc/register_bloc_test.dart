import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/services/social_auth_service.dart';
import 'package:vocabik_app/features/auth/domain/entities/user.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/get_me_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/login_with_google_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_event.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_state.dart';

class MockSocialAuthService implements SocialAuthService {
  String? mockIdToken;
  bool shouldThrow = false;

  @override
  Future<String?> getGoogleIdToken() async {
    if (shouldThrow) {
      throw Exception('Google sign-in exception');
    }
    return mockIdToken;
  }

  @override
  Future<void> signOut() async {}
}

class MockAuthRepository implements AuthRepository {
  User? mockUser;
  Failure? mockFailure;

  @override
  Future<Either<Failure, User>> loginWithGoogle(
    String idToken, {
    String? anonymousSessionId,
  }) async {
    if (mockFailure != null) {
      return left(mockFailure!);
    }
    return right(
      mockUser ??
          const User(
            id: 'google_user_1',
            email: 'user@gmail.com',
            displayName: 'Google User',
            tier: 'free',
            emailVerified: true,
          ),
    );
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (mockFailure != null) {
      return left(mockFailure!);
    }
    return right(null);
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
  Future<Either<Failure, void>> signOut() async => right(null);

  @override
  Future<Either<Failure, User>> verifyEmail(String token) =>
      throw UnimplementedError();
}

void main() {
  late MockSocialAuthService socialAuthService;
  late MockAuthRepository repository;
  late RegisterUseCase registerUseCase;
  late LoginWithGoogleUseCase loginWithGoogleUseCase;
  late AuthBloc authBloc;
  late RegisterBloc registerBloc;

  setUp(() {
    socialAuthService = MockSocialAuthService();
    repository = MockAuthRepository();
    registerUseCase = RegisterUseCase(repository);
    loginWithGoogleUseCase = LoginWithGoogleUseCase(repository);
    authBloc = AuthBloc(
      SignOutUseCase(repository),
      GetMeUseCase(repository),
    );
    registerBloc = RegisterBloc(
      registerUseCase,
      loginWithGoogleUseCase,
      socialAuthService,
      authBloc,
    );
  });

  tearDown(() {
    registerBloc.close();
    authBloc.close();
  });

  group('RegisterWithGoogleSubmitted', () {
    test('emits [loading, socialSuccess] on successful Google register/login',
        () async {
      socialAuthService.mockIdToken = 'valid_id_token';
      final states = <RegisterState>[];
      registerBloc.stream.listen(states.add);

      registerBloc.add(const RegisterWithGoogleSubmitted());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0].status, RegisterStatus.loading);
      expect(states[1].status, RegisterStatus.socialSuccess);
      expect(authBloc.state.status, AuthStatus.success);
      expect(authBloc.state.user?.email, 'user@gmail.com');
    });

    test('emits [loading, initial] when user cancels Google sign up', () async {
      socialAuthService.mockIdToken = null;
      final states = <RegisterState>[];
      registerBloc.stream.listen(states.add);

      registerBloc.add(const RegisterWithGoogleSubmitted());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0].status, RegisterStatus.loading);
      expect(states[1].status, RegisterStatus.initial);
    });

    test('emits [loading, failure] when Google use case returns Failure',
        () async {
      socialAuthService.mockIdToken = 'invalid_id_token';
      repository.mockFailure =
          const InvalidCredentialsFailure('Google Token invalid');
      final states = <RegisterState>[];
      registerBloc.stream.listen(states.add);

      registerBloc.add(const RegisterWithGoogleSubmitted());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0].status, RegisterStatus.loading);
      expect(states[1].status, RegisterStatus.failure);
      expect(states[1].errorMessage, 'Google Token invalid');
    });

    test('emits [loading, failure] when Google SDK throws error', () async {
      socialAuthService.shouldThrow = true;
      final states = <RegisterState>[];
      registerBloc.stream.listen(states.add);

      registerBloc.add(const RegisterWithGoogleSubmitted());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0].status, RegisterStatus.loading);
      expect(states[1].status, RegisterStatus.failure);
    });
  });
}

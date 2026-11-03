import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/services/social_auth_service.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/data/models/user_model.dart';
import 'package:vocabik_app/features/auth/domain/entities/user.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/get_me_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/login_with_google_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_state.dart';

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  String? accessToken;
  String? refreshToken;
  UserModel? user;
  bool skipped = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    user = null;
    skipped = false;
  }

  @override
  String? getAccessToken() => accessToken;

  @override
  String? getRefreshToken() => refreshToken;

  @override
  bool isCefrSkipped() => skipped;

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    this.user = user;
  }

  @override
  UserModel? getUser() => user;

  @override
  Future<void> setCefrSkipped(bool value) async {
    skipped = value;
  }

  String? legalAcceptedVersion;
  @override
  Future<void> setLegalAccepted(String version, {String? userId}) async {
    legalAcceptedVersion = version;
  }

  @override
  bool isLegalAccepted(String version, {String? userId}) =>
      legalAcceptedVersion == version;
}

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
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String displayName,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> resendVerificationEmail(String email) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> setCefrSkipped(bool value) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> signOut() async => right(null);

  @override
  Future<Either<Failure, User>> verifyEmail(String token) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteAccount({String? password, String? reason}) async =>
      right(null);
}

void main() {
  late MockSocialAuthService socialAuthService;
  late MockAuthRepository repository;
  late LoginWithGoogleUseCase loginWithGoogleUseCase;
  late LoginUseCase loginUseCase;
  late FakeAuthLocalDataSource localDataSource;
  late AuthBloc authBloc;
  late LoginCubit cubit;

  setUp(() {
    socialAuthService = MockSocialAuthService();
    repository = MockAuthRepository();
    localDataSource = FakeAuthLocalDataSource();
    loginWithGoogleUseCase = LoginWithGoogleUseCase(repository);
    loginUseCase = LoginUseCase(repository);
    authBloc = AuthBloc(
      SignOutUseCase(repository),
      GetMeUseCase(repository),
      localDataSource,
    );
    cubit = LoginCubit(
      loginUseCase,
      loginWithGoogleUseCase,
      socialAuthService,
      authBloc,
      localDataSource,
    );
  });

  tearDown(() {
    cubit.close();
    authBloc.close();
  });

  group('loginWithGoogle', () {
    test('emits [loading, success] on successful Google login', () async {
      socialAuthService.mockIdToken = 'valid_id_token';
      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithGoogle();
      await Future.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].status, LoginStatus.loading);
      expect(states[1].status, LoginStatus.success);
      expect(authBloc.state.status, AuthStatus.success);
      expect(authBloc.state.user?.email, 'user@gmail.com');
    });

    test('emits [loading, initial] when user cancels Google sign in', () async {
      socialAuthService.mockIdToken = null;
      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithGoogle();
      await Future.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].status, LoginStatus.loading);
      expect(states[1].status, LoginStatus.initial);
    });

    test('emits [loading, failure] when use case returns Failure', () async {
      socialAuthService.mockIdToken = 'invalid_id_token';
      repository.mockFailure = const InvalidCredentialsFailure('Token invalid');
      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithGoogle();
      await Future.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].status, LoginStatus.loading);
      expect(states[1].status, LoginStatus.failure);
      expect(states[1].errorMessage, 'Token invalid');
    });

    test('emits [loading, failure] when Google SDK throws error', () async {
      socialAuthService.shouldThrow = true;
      final states = <LoginState>[];
      cubit.stream.listen(states.add);

      await cubit.loginWithGoogle();
      await Future.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].status, LoginStatus.loading);
      expect(states[1].status, LoginStatus.failure);
    });
  });
}

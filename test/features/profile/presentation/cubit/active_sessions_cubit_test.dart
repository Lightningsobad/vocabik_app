import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/auth/domain/entities/user.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/get_sessions_use_case.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/active_sessions_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/active_sessions_state.dart';

class FakeAuthRepository implements AuthRepository {
  final List<UserSession> sessions;
  final bool shouldFail;

  FakeAuthRepository({
    this.sessions = const [],
    this.shouldFail = false,
  });

  @override
  Future<Either<Failure, List<UserSession>>> getSessions() async {
    if (shouldFail) {
      return left(const ServerFailure('Network error'));
    }
    return right(sessions);
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, User>> getMe() async => throw UnimplementedError();

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, User>> loginWithGoogle(
    String idToken, {
    String? anonymousSessionId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String displayName,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> resendVerificationEmail(String email) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> setCefrSkipped(bool value) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> signOut() async => throw UnimplementedError();

  @override
  Future<Either<Failure, User>> verifyEmail(String token) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteAccount({String? password, String? reason}) async =>
      throw UnimplementedError();
}

void main() {
  group('ActiveSessionsCubit', () {
    final session1 = UserSession(
      id: '1',
      device: 'Chrome trên Windows',
      ip: '1.1.1.1',
      createdAt: DateTime.parse('2026-09-01T10:00:00Z'),
      lastActive: DateTime.parse('2026-09-01T10:00:00Z'),
      current: false,
    );

    final currentSession = UserSession(
      id: '2',
      device: 'Chrome trên Windows',
      ip: '1.1.1.2',
      createdAt: DateTime.parse('2026-08-30T10:00:00Z'),
      lastActive: DateTime.parse('2026-08-30T10:00:00Z'),
      current: true,
    );

    test('initial state has status initial and empty sessions', () {
      final cubit = ActiveSessionsCubit(
        GetSessionsUseCase(FakeAuthRepository()),
      );
      expect(cubit.state.status, ActiveSessionsStatus.initial);
      expect(cubit.state.sessions, isEmpty);
    });

    test('loadSessions emits [loading, success] with current session placed first', () async {
      final fakeRepo = FakeAuthRepository(sessions: [session1, currentSession]);
      final cubit = ActiveSessionsCubit(GetSessionsUseCase(fakeRepo));

      final states = <ActiveSessionsState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.loadSessions();
      await Future.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].status, ActiveSessionsStatus.loading);
      expect(states[1].status, ActiveSessionsStatus.success);
      expect(states[1].sessions.first.id, '2'); // current session first
      expect(states[1].sessions.first.current, true);
      expect(states[1].sessions[1].id, '1');

      await subscription.cancel();
      await cubit.close();
    });

    test('loadSessions emits [loading, failure] when repository returns error', () async {
      final fakeRepo = FakeAuthRepository(shouldFail: true);
      final cubit = ActiveSessionsCubit(GetSessionsUseCase(fakeRepo));

      final states = <ActiveSessionsState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.loadSessions();
      await Future.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0].status, ActiveSessionsStatus.loading);
      expect(states[1].status, ActiveSessionsStatus.failure);
      expect(states[1].errorMessage, 'Network error');

      await subscription.cancel();
      await cubit.close();
    });
  });
}

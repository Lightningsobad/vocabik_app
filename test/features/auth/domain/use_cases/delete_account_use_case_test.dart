import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/delete_account_use_case.dart';

class MockAuthRepositoryForDeletion implements AuthRepository {
  String? capturedPassword;
  String? capturedReason;
  Either<Failure, void> result = right(null);

  @override
  Future<Either<Failure, void>> deleteAccount({
    String? password,
    String? reason,
  }) async {
    capturedPassword = password;
    capturedReason = reason;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late DeleteAccountUseCase useCase;
  late MockAuthRepositoryForDeletion repository;

  setUp(() {
    repository = MockAuthRepositoryForDeletion();
    useCase = DeleteAccountUseCase(repository);
  });

  test('should call repository.deleteAccount with password and reason', () async {
    repository.result = right(null);

    final result = await useCase(password: 'myPassword123', reason: 'Leaving app');

    expect(result, right(null));
    expect(repository.capturedPassword, 'myPassword123');
    expect(repository.capturedReason, 'Leaving app');
  });

  test('should return PasswordRequiredFailure when repository fails with it', () async {
    repository.result = left(const PasswordRequiredFailure());

    final result = await useCase();

    expect(result, left(const PasswordRequiredFailure()));
  });

  test('should return InvalidPasswordFailure when repository fails with it', () async {
    repository.result = left(const InvalidPasswordFailure());

    final result = await useCase(password: 'wrongPassword');

    expect(result, left(const InvalidPasswordFailure()));
  });
}

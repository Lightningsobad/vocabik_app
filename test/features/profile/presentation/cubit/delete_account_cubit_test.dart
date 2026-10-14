import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/delete_account_state.dart';

class MockAuthRepositoryForCubit implements AuthRepository {
  Either<Failure, void> result = right(null);

  @override
  Future<Either<Failure, void>> deleteAccount({
    String? password,
    String? reason,
  }) async {
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late DeleteAccountCubit cubit;
  late MockAuthRepositoryForCubit repository;

  setUp(() {
    repository = MockAuthRepositoryForCubit();
    final useCase = DeleteAccountUseCase(repository);
    cubit = DeleteAccountCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be DeleteAccountStatus.initial', () {
    expect(cubit.state, const DeleteAccountState());
  });

  test('emits [loading, success] when deleteAccount succeeds', () async {
    repository.result = right(null);

    final expectedStates = [
      const DeleteAccountState(status: DeleteAccountStatus.loading),
      const DeleteAccountState(status: DeleteAccountStatus.success),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.deleteAccount(password: 'pass123');
  });

  test('emits [loading, failure] with PasswordRequiredFailure', () async {
    repository.result = left(const PasswordRequiredFailure());

    final expectedStates = [
      const DeleteAccountState(status: DeleteAccountStatus.loading),
      const DeleteAccountState(
        status: DeleteAccountStatus.failure,
        failure: PasswordRequiredFailure(),
        errorMessage: 'Password is required',
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.deleteAccount();
    expect(cubit.state.isPasswordRequired, isTrue);
  });

  test('emits [loading, failure] with InvalidPasswordFailure', () async {
    repository.result = left(const InvalidPasswordFailure());

    final expectedStates = [
      const DeleteAccountState(status: DeleteAccountStatus.loading),
      const DeleteAccountState(
        status: DeleteAccountStatus.failure,
        failure: InvalidPasswordFailure(),
        errorMessage: 'Incorrect password',
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.deleteAccount(password: 'wrong');
    expect(cubit.state.isInvalidPassword, isTrue);
  });
}

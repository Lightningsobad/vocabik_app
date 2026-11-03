import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/profile/data/models/update_profile_response_model.dart';
import 'package:vocabik_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:vocabik_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/update_profile_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/update_profile_state.dart';

class MockProfileRepository implements ProfileRepository {
  UpdateProfileResponseModel? response;
  Failure? failure;

  @override
  Future<Either<Failure, UpdateProfileResponseModel>> updateProfile({
    String? cefrLevel,
    String? displayName,
  }) async {
    if (failure != null) {
      return left(failure!);
    }
    return right(response ?? const UpdateProfileResponseModel());
  }
}

void main() {
  late MockProfileRepository repository;
  late UpdateProfileUseCase useCase;
  late UpdateProfileCubit cubit;

  setUp(() {
    repository = MockProfileRepository();
    useCase = UpdateProfileUseCase(repository);
    cubit = UpdateProfileCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has status initial', () {
    expect(cubit.state.status, UpdateProfileStatus.initial);
    expect(cubit.state.updatedProfile, isNull);
    expect(cubit.state.errorMessage, isNull);
  });

  test('updateProfile emits [loading, success] on success', () async {
    const expected = UpdateProfileResponseModel(
      cefrLevel: 'A1',
      displayName: 'Quang 226789',
    );
    repository.response = expected;

    expectLater(
      cubit.stream,
      emitsInOrder([
        const UpdateProfileState(status: UpdateProfileStatus.loading),
        const UpdateProfileState(
          status: UpdateProfileStatus.success,
          updatedProfile: expected,
        ),
      ]),
    );

    await cubit.updateProfile(displayName: 'Quang 226789', cefrLevel: 'A1');
  });

  test('updateProfile emits [loading, failure] on error', () async {
    repository.failure = const ServerFailure('Dữ liệu không hợp lệ.');

    expectLater(
      cubit.stream,
      emitsInOrder([
        const UpdateProfileState(status: UpdateProfileStatus.loading),
        const UpdateProfileState(
          status: UpdateProfileStatus.failure,
          errorMessage: 'Dữ liệu không hợp lệ.',
        ),
      ]),
    );

    await cubit.updateProfile(displayName: 'Quang 226789');
  });
}

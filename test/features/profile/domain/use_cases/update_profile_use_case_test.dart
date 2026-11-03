import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/profile/data/models/update_profile_response_model.dart';
import 'package:vocabik_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:vocabik_app/features/profile/domain/use_cases/update_profile_use_case.dart';

class MockProfileRepository implements ProfileRepository {
  UpdateProfileResponseModel? response;
  Failure? failure;
  String? capturedCefrLevel;
  String? capturedDisplayName;

  @override
  Future<Either<Failure, UpdateProfileResponseModel>> updateProfile({
    String? cefrLevel,
    String? displayName,
  }) async {
    capturedCefrLevel = cefrLevel;
    capturedDisplayName = displayName;
    if (failure != null) {
      return left(failure!);
    }
    return right(response ?? const UpdateProfileResponseModel());
  }
}

void main() {
  late MockProfileRepository repository;
  late UpdateProfileUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = UpdateProfileUseCase(repository);
  });

  test('calls repository.updateProfile and returns response on success', () async {
    const expectedResponse = UpdateProfileResponseModel(
      cefrLevel: 'A1',
      displayName: 'Quang 226789',
    );
    repository.response = expectedResponse;

    final result = await useCase(
      displayName: 'Quang 226789',
      cefrLevel: 'A1',
    );

    expect(repository.capturedDisplayName, 'Quang 226789');
    expect(repository.capturedCefrLevel, 'A1');
    expect(result, const Right(expectedResponse));
  });

  test('returns failure when repository fails', () async {
    repository.failure = const ServerFailure('Lỗi máy chủ');

    final result = await useCase(
      displayName: 'Quang 226789',
    );

    expect(repository.capturedDisplayName, 'Quang 226789');
    expect(result, const Left(ServerFailure('Lỗi máy chủ')));
  });
}

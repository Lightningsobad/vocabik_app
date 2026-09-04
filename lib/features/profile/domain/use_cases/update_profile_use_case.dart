import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../repositories/profile_repository.dart';
import '../../data/models/update_profile_response_model.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, UpdateProfileResponseModel>> call({
    String? cefrLevel,
    String? displayName,
  }) {
    return _repository.updateProfile(
      cefrLevel: cefrLevel,
      displayName: displayName,
    );
  }
}

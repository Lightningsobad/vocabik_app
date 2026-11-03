import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../../data/models/update_profile_response_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UpdateProfileResponseModel>> updateProfile({
    String? cefrLevel,
    String? displayName,
  });
}


import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateProfile({required String cefrLevel});
}

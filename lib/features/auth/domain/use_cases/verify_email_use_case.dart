import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyEmailUseCase {
  final AuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  Future<Either<Failure, User>> call(String token) {
    return _repository.verifyEmail(token);
  }
}

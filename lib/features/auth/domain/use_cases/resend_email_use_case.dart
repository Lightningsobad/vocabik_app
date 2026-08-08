import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

@injectable
class ResendEmailUseCase {
  final AuthRepository _repository;

  ResendEmailUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) {
    return _repository.resendVerificationEmail(email);
  }
}

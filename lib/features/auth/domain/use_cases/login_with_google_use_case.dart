import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginWithGoogleUseCase {
  final AuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String idToken,
    String? anonymousSessionId,
  }) {
    return _repository.loginWithGoogle(
      idToken,
      anonymousSessionId: anonymousSessionId,
    );
  }
}

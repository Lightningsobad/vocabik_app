import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String token,
    required String newPassword,
  }) {
    return _repository.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GetMeUseCase {
  final AuthRepository _repository;

  GetMeUseCase(this._repository);

  Future<Either<Failure, User>> call() {
    return _repository.getMe();
  }
}

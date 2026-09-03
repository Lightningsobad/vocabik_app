import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../entities/user_session.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GetSessionsUseCase {
  final AuthRepository _repository;

  GetSessionsUseCase(this._repository);

  Future<Either<Failure, List<UserSession>>> call() {
    return _repository.getSessions();
  }
}

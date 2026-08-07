import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

@injectable
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.signOut();
  }
}

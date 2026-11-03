import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

@injectable
class SetCefrSkippedUseCase {
  final AuthRepository _repository;

  SetCefrSkippedUseCase(this._repository);

  Future<Either<Failure, void>> call(bool value) {
    return _repository.setCefrSkipped(value);
  }
}

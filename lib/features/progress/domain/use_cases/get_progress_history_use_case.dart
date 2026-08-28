import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/progress_history.dart';
import '../repositories/progress_repository.dart';

@lazySingleton
class GetProgressHistoryUseCase {
  final ProgressRepository _repository;

  GetProgressHistoryUseCase(this._repository);

  Future<Either<Failure, ProgressHistory>> call() {
    return _repository.getProgressHistory();
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/progress_summary.dart';
import '../repositories/progress_repository.dart';

@lazySingleton
class GetProgressSummaryUseCase {
  final ProgressRepository _repository;

  GetProgressSummaryUseCase(this._repository);

  Future<Either<Failure, ProgressSummary>> call() {
    return _repository.getProgressSummary();
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/progress_error_insights.dart';
import '../repositories/progress_repository.dart';

@lazySingleton
class GetProgressErrorInsightsUseCase {
  final ProgressRepository _repository;

  GetProgressErrorInsightsUseCase(this._repository);

  Future<Either<Failure, ProgressErrorInsights>> call() {
    return _repository.getProgressErrorInsights();
  }
}

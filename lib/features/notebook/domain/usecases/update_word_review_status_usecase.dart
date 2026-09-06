import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_entity.dart';
import '../repositories/notebook_repository.dart';

@lazySingleton
class UpdateWordReviewStatusUseCase {
  final NotebookRepository _repository;

  UpdateWordReviewStatusUseCase(this._repository);

  Future<Either<Failure, WordEntity>> call({
    required String id,
    required bool needsReview,
  }) {
    return _repository.updateReviewStatus(
      id: id,
      needsReview: needsReview,
    );
  }
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/word_entity.dart';

abstract class NotebookRepository {
  Future<Either<Failure, List<WordEntity>>> getWords();
  Future<Either<Failure, WordEntity>> updateReviewStatus({
    required String id,
    required bool needsReview,
  });
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notebook_words_result.dart';
import '../entities/word_entity.dart';

abstract class NotebookRepository {
  Future<Either<Failure, NotebookWordsResult>> getWords({String? search});
  Future<Either<Failure, WordEntity>> updateReviewStatus({
    required String id,
    required bool needsReview,
  });
}

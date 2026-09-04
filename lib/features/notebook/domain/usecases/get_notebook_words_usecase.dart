import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_entity.dart';
import '../repositories/notebook_repository.dart';

@lazySingleton
class GetNotebookWordsUseCase {
  final NotebookRepository _repository;

  GetNotebookWordsUseCase(this._repository);

  Future<Either<Failure, List<WordEntity>>> call() {
    return _repository.getWords();
  }
}

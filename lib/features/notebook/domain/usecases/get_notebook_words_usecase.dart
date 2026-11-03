import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/notebook_words_result.dart';
import '../repositories/notebook_repository.dart';

@lazySingleton
class GetNotebookWordsUseCase {
  final NotebookRepository _repository;

  GetNotebookWordsUseCase(this._repository);

  Future<Either<Failure, NotebookWordsResult>> call({String? search}) {
    return _repository.getWords(search: search);
  }
}

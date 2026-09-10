import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notebook_words_result.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/notebook_repository.dart';
import '../datasources/notebook_remote_data_source.dart';

@LazySingleton(as: NotebookRepository)
class NotebookRepositoryImpl implements NotebookRepository {
  final NotebookRemoteDataSource _remoteDataSource;

  NotebookRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NotebookWordsResult>> getWords({String? search}) async {
    try {
      final result = await _remoteDataSource.getWords(search: search);
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WordEntity>> updateReviewStatus({
    required String id,
    required bool needsReview,
  }) async {
    try {
      final result = await _remoteDataSource.updateReviewStatus(
        id: id,
        needsReview: needsReview,
      );
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

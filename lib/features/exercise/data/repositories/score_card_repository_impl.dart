import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/exercise/data/datasources/score_card_remote_datasource.dart';
import 'package:vocabik_app/features/exercise/data/models/score_card_request.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/score_card_repository.dart';

@LazySingleton(as: ScoreCardRepository)
class ScoreCardRepositoryImpl implements ScoreCardRepository {
  final ScoreCardRemoteDataSource remoteDataSource;

  ScoreCardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createScoreCard({
    required ScoreCardRequest request,
    CancelToken? cancelToken,
  }) async {
    try {
      final scoreCardId = await remoteDataSource.createScoreCard(
        request: request,
        cancelToken: cancelToken,
      );
      return Right(scoreCardId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  String getScoreCardImageUrl(String scoreCardId) {
    return remoteDataSource.getScoreCardImageUrl(scoreCardId);
  }
}

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/exercise/data/models/score_card_request.dart';

abstract class ScoreCardRepository {
  Future<Either<Failure, String>> createScoreCard({
    required ScoreCardRequest request,
    CancelToken? cancelToken,
  });

  String getScoreCardImageUrl(String scoreCardId);
}

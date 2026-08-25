import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';

abstract class ScoreCardRepository {
  Future<Either<Failure, String>> createScoreCard({
    required String videoId,
    required String cefrLevel,
    required int accuracyScore,
    AppCancelToken? cancelToken,
  });

  String getScoreCardImageUrl(String scoreCardId);
}


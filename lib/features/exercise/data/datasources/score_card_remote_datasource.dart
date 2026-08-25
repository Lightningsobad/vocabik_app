import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/exercise/data/models/score_card_request.dart';

abstract class ScoreCardRemoteDataSource {
  Future<String> createScoreCard({
    required ScoreCardRequest request,
    CancelToken? cancelToken,
  });

  String getScoreCardImageUrl(String scoreCardId);
}

@LazySingleton(as: ScoreCardRemoteDataSource)
class ScoreCardRemoteDataSourceImpl implements ScoreCardRemoteDataSource {
  final Dio dio;

  ScoreCardRemoteDataSourceImpl(this.dio);

  @override
  Future<String> createScoreCard({
    required ScoreCardRequest request,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/public/score-cards',
        data: request.toJson(),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final id = data['id'] ?? data['scoreCardId'] ?? data['data']?['id'];
          if (id != null) return id.toString();
        } else if (data is String) {
          return data;
        }
        throw ServerException('Invalid score card response format');
      } else {
        throw ServerException('Failed to create score card');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const RequestCancelledException();
      }
      throw ServerException(e.message ?? 'Failed to create score card');
    }
  }

  @override
  String getScoreCardImageUrl(String scoreCardId) {
    return '${dio.options.baseUrl}/public/score-cards/$scoreCardId/image';
  }
}

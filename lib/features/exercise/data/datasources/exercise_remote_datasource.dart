import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/exercise/data/models/exercise_model.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';

abstract class ExerciseRemoteDataSource {
  Future<ExerciseModel> getExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    CancelToken? cancelToken,
  });
}

@LazySingleton(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final Dio dio;

  ExerciseRemoteDataSourceImpl(this.dio);

  @override
  Future<ExerciseModel> getExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/public/exercises',
        queryParameters: {
          'video_id': videoId,
          'cefr_level': cefrLevel,
          'version_id': versionId,
        },
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return await compute(_parseExerciseModel, data);
        } else {
          return ExerciseModel.fromJson(data as Map<String, dynamic>);
        }
      } else {
        throw ServerException('Failed to load exercise');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw ServerException('Request cancelled');
      }
      throw ServerException(e.message ?? 'Failed to load exercise');
    }
  }
}

ExerciseModel _parseExerciseModel(Map<String, dynamic> json) {
  return ExerciseModel.fromJson(json);
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/exercise/data/models/exercise_model.dart';
import 'package:vocabik_app/features/exercise/data/models/progress_request.dart';
import 'package:vocabik_app/features/exercise/data/models/translation_model.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';

abstract class ExerciseRemoteDataSource {
  Future<ExerciseModel> getExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    CancelToken? cancelToken,
  });

  Future<List<TranslationModel>> getVideoTranslations({
    required String videoId,
    required String lang,
    required String language,
    CancelToken? cancelToken,
  });

  Future<void> submitProgress({
    required ProgressRequest request,
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
        throw const RequestCancelledException();
      }
      throw ServerException(e.message ?? 'Failed to load exercise');
    }
  }

  @override
  Future<List<TranslationModel>> getVideoTranslations({
    required String videoId,
    required String lang,
    required String language,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/public/videos/$videoId/translations',
        queryParameters: {
          'lang': lang,
          'language': language,
        },
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List) {
          return await compute(_parseTranslationList, data);
        }
        return [];
      } else {
        throw ServerException('Failed to load translations');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const RequestCancelledException();
      }
      throw ServerException(e.message ?? 'Failed to load translations');
    }
  }

  @override
  Future<void> submitProgress({
    required ProgressRequest request,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/progress',
        data: request.toJson(),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return;
      } else {
        throw ServerException('Failed to submit exercise progress');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const RequestCancelledException();
      }
      throw ServerException(e.message ?? 'Failed to submit exercise progress');
    }
  }
}

ExerciseModel _parseExerciseModel(Map<String, dynamic> json) {
  return ExerciseModel.fromJson(json);
}

List<TranslationModel> _parseTranslationList(dynamic data) {
  if (data is List) {
    return data
        .map((item) => TranslationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  return [];
}

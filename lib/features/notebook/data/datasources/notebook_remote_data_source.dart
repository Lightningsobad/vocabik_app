import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/word_model.dart';

abstract class NotebookRemoteDataSource {
  Future<List<WordModel>> getWords({CancelToken? cancelToken});
  Future<WordModel> updateReviewStatus({
    required String id,
    required bool needsReview,
    CancelToken? cancelToken,
  });
}

List<WordModel> _parseWords(dynamic data) {
  if (data is List) {
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => WordModel.fromJson(e))
        .toList();
  } else if (data is Map<String, dynamic>) {
    final list = data['items'] ?? data['words'] ?? data['data'] ?? [];
    if (list is List) {
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => WordModel.fromJson(e))
          .toList();
    }
  }
  return [];
}

WordModel _parseWord(dynamic data) {
  if (data is Map<String, dynamic>) {
    return WordModel.fromJson(data);
  }
  throw const FormatException('Invalid word response format');
}

@LazySingleton(as: NotebookRemoteDataSource)
class NotebookRemoteDataSourceImpl implements NotebookRemoteDataSource {
  final Dio _dio;

  NotebookRemoteDataSourceImpl(this._dio);

  @override
  Future<List<WordModel>> getWords({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/vocabulary/words',
        cancelToken: cancelToken,
      );
      return await compute(_parseWords, response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException(
          'API Error: ${e.response?.statusCode} - ${e.message}',
        );
      }
      throw ServerException('Parse Error: $e');
    }
  }

  @override
  Future<WordModel> updateReviewStatus({
    required String id,
    required bool needsReview,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        '/vocabulary/words/$id',
        data: {'needs_review': needsReview},
        cancelToken: cancelToken,
      );
      return await compute(_parseWord, response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException(
          'API Error: ${e.response?.statusCode} - ${e.message}',
        );
      }
      throw ServerException('Parse Error: $e');
    }
  }
}

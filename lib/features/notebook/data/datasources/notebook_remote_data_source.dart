import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/notebook_words_response_model.dart';
import '../models/word_model.dart';

abstract class NotebookRemoteDataSource {
  Future<NotebookWordsResponseModel> getWords({
    String? search,
    CancelToken? cancelToken,
  });
  Future<WordModel> updateReviewStatus({
    required String id,
    required bool needsReview,
    CancelToken? cancelToken,
  });
}

NotebookWordsResponseModel _parseWordsResponse(dynamic data) {
  if (data is Map<String, dynamic>) {
    return NotebookWordsResponseModel.fromJson(data);
  } else if (data is List) {
    final words = data
        .whereType<Map<String, dynamic>>()
        .map((e) => WordModel.fromJson(e))
        .toList();
    return NotebookWordsResponseModel(words: words, total: words.length);
  }
  return const NotebookWordsResponseModel(words: [], total: 0);
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
  Future<NotebookWordsResponseModel> getWords({
    String? search,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await _dio.get(
        '/vocabulary/words',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        cancelToken: cancelToken,
      );
      return await compute(_parseWordsResponse, response.data);
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

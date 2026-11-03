import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/progress_summary_model.dart';
import '../models/progress_history_model.dart';
import '../models/progress_error_insights_model.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressSummaryModel> getProgressSummary({CancelToken? cancelToken});
  Future<ProgressHistoryModel> getProgressHistory({CancelToken? cancelToken});
  Future<ProgressErrorInsightsModel> getProgressErrorInsights({CancelToken? cancelToken});
}

ProgressSummaryModel _parseProgressSummary(Map<String, dynamic> data) =>
    ProgressSummaryModel.fromJson(data);

ProgressHistoryModel _parseProgressHistory(Map<String, dynamic> data) =>
    ProgressHistoryModel.fromJson(data);

ProgressErrorInsightsModel _parseProgressErrorInsights(Map<String, dynamic> data) =>
    ProgressErrorInsightsModel.fromJson(data);

@LazySingleton(as: ProgressRemoteDataSource)
class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final Dio _dio;

  ProgressRemoteDataSourceImpl(this._dio);

  @override
  Future<ProgressSummaryModel> getProgressSummary({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/progress/summary',
        cancelToken: cancelToken,
      );
      return await compute(
        _parseProgressSummary,
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      throw ServerException('Parse Error: $e');
    }
  }

  @override
  Future<ProgressHistoryModel> getProgressHistory({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/progress/history',
        cancelToken: cancelToken,
      );
      return await compute(
        _parseProgressHistory,
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      throw ServerException('Parse Error: $e');
    }
  }

  @override
  Future<ProgressErrorInsightsModel> getProgressErrorInsights({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/progress/error-insights',
        cancelToken: cancelToken,
      );
      return await compute(
        _parseProgressErrorInsights,
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      throw ServerException('Parse Error: $e');
    }
  }
}

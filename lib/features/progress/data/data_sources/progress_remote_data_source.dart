import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/gamification_model.dart';
import '../models/daily_streak_model.dart';

abstract class ProgressRemoteDataSource {
  Future<GamificationModel> getGamificationMe({CancelToken? cancelToken});
  Future<DailyStreakModel> getDailyChallengeStreak({CancelToken? cancelToken});
}

GamificationModel _parseGamification(Map<String, dynamic> data) => GamificationModel.fromJson(data);
DailyStreakModel _parseDailyStreak(dynamic data) => DailyStreakModel.fromJson(data);

@LazySingleton(as: ProgressRemoteDataSource)
class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final Dio _dio;

  ProgressRemoteDataSourceImpl(this._dio);

  @override
  Future<GamificationModel> getGamificationMe({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/gamification/me',
        cancelToken: cancelToken,
      );
      return await compute(_parseGamification, response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        if (e.response?.statusCode == 401) {
          final authHeader = e.requestOptions.headers['Authorization']?.toString() ?? 'null';
          print('[DEBUG 401 on /gamification/me] AuthHeader: $authHeader');
        }
        throw ServerException('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      throw ServerException('Parse Error: $e');
    }
  }

  @override
  Future<DailyStreakModel> getDailyChallengeStreak({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/daily-challenge/streak',
        cancelToken: cancelToken,
      );
      return await compute(_parseDailyStreak, response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        if (e.response?.statusCode == 401) {
          final authHeader = e.requestOptions.headers['Authorization']?.toString() ?? 'null';
          print('[DEBUG 401 on /daily-challenge/streak] AuthHeader: $authHeader');
        }
        throw ServerException('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      throw ServerException('Parse Error: $e');
    }
  }
}

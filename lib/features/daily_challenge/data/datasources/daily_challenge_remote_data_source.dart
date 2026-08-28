import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/daily_challenge_config_model.dart';
import '../models/daily_challenge_leaderboard_model.dart';
import '../models/daily_challenge_streak_model.dart';

abstract class DailyChallengeRemoteDataSource {
  Future<DailyChallengeResponseModel> getConfig({CancelToken? cancelToken});
  Future<List<DailyChallengeLeaderboardItemModel>> getLeaderboard({
    required String date,
    CancelToken? cancelToken,
  });
  Future<DailyChallengeStreakModel> getStreak({CancelToken? cancelToken});
}

DailyChallengeResponseModel _parseConfig(dynamic data) {
  if (data is Map<String, dynamic>) {
    return DailyChallengeResponseModel.fromJson(data);
  }
  throw const FormatException('Invalid config response format');
}

List<DailyChallengeLeaderboardItemModel> _parseLeaderboard(dynamic data) {
  if (data is List) {
    return data.asMap().entries.map((entry) {
      final item = entry.value;
      if (item is Map<String, dynamic>) {
        return DailyChallengeLeaderboardItemModel.fromJson(
          item,
          defaultRank: entry.key + 1,
        );
      }
      return DailyChallengeLeaderboardItemModel(
        rank: entry.key + 1,
        userId: '',
        userName: 'User',
      );
    }).toList();
  } else if (data is Map<String, dynamic>) {
    final list = data['rows'] ?? data['items'] ?? data['leaderboard'] ?? data['data'] ?? [];
    if (list is List) {
      return list.asMap().entries.map((entry) {
        final item = entry.value;
        if (item is Map<String, dynamic>) {
          return DailyChallengeLeaderboardItemModel.fromJson(
            item,
            defaultRank: entry.key + 1,
          );
        }
        return DailyChallengeLeaderboardItemModel(
          rank: entry.key + 1,
          userId: '',
          userName: 'User',
        );
      }).toList();
    }
  }
  return [];
}

DailyChallengeStreakModel _parseStreak(dynamic data) {
  if (data is Map<String, dynamic>) {
    return DailyChallengeStreakModel.fromJson(data);
  }
  throw const FormatException('Invalid streak response format');
}

@LazySingleton(as: DailyChallengeRemoteDataSource)
class DailyChallengeRemoteDataSourceImpl
    implements DailyChallengeRemoteDataSource {
  final Dio _dio;

  DailyChallengeRemoteDataSourceImpl(this._dio);

  @override
  Future<DailyChallengeResponseModel> getConfig({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '/daily-challenge/config',
        cancelToken: cancelToken,
      );
      return await compute(_parseConfig, response.data);
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
  Future<List<DailyChallengeLeaderboardItemModel>> getLeaderboard({
    required String date,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '/daily-challenge/leaderboard',
        queryParameters: {'date': date},
        cancelToken: cancelToken,
      );
      return await compute(_parseLeaderboard, response.data);
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
  Future<DailyChallengeStreakModel> getStreak({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '/daily-challenge/streak',
        cancelToken: cancelToken,
      );
      return await compute(_parseStreak, response.data);
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

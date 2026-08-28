import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/leaderboard_response_model.dart';

abstract class LeaderboardRemoteDataSource {
  Future<LeaderboardResponseModel> getLeaderboard({
    required String period,
    required String scope,
    String? currentUserId,
    CancelToken? cancelToken,
  });
}

LeaderboardResponseModel _parseLeaderboardResponse(dynamic data) {
  if (data is Map<String, dynamic>) {
    return LeaderboardResponseModel.fromJson(data);
  } else if (data is Map) {
    return LeaderboardResponseModel.fromJson(Map<String, dynamic>.from(data));
  }
  throw const FormatException('Invalid leaderboard response format');
}

@LazySingleton(as: LeaderboardRemoteDataSource)
class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final Dio _dio;

  LeaderboardRemoteDataSourceImpl(this._dio);

  @override
  Future<LeaderboardResponseModel> getLeaderboard({
    required String period,
    required String scope,
    String? currentUserId,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '/leaderboard',
        queryParameters: {
          'period': period,
          'scope': scope,
        },
        cancelToken: cancelToken,
      );

      if (response.data is Map) {
        final model = await compute(_parseLeaderboardResponse, response.data);
        return model;
      }
      throw const FormatException('Invalid leaderboard response format');
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

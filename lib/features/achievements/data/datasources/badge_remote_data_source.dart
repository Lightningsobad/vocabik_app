import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/badge_model.dart';

abstract class BadgeRemoteDataSource {
  Future<List<BadgeModel>> getBadges({
    String? category,
    CancelToken? cancelToken,
  });
}

List<BadgeModel> _parseBadges(dynamic data) {
  if (data is Map<String, dynamic>) {
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } else if (data is List) {
    return data
        .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}

@LazySingleton(as: BadgeRemoteDataSource)
class BadgeRemoteDataSourceImpl implements BadgeRemoteDataSource {
  final Dio _dio;

  BadgeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BadgeModel>> getBadges({
    String? category,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (category != null && category.trim().isNotEmpty) {
        queryParameters['category'] = category.trim();
      }

      final response = await _dio.get(
        '/me/badges',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        cancelToken: cancelToken,
      );
      return await compute(_parseBadges, response.data);
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

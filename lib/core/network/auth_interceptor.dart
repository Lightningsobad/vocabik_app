import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/data/data_sources/auth_local_data_source.dart';
import '../../features/auth/data/models/auth_response_model.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;
  final VoidCallback? onSessionExpired;
  late final Dio _refreshDio;

  AuthInterceptor({
    required this.dio,
    required this.authLocalDataSource,
    this.onSessionExpired,
    Dio? refreshDio,
  }) {
    _refreshDio = refreshDio ??
        Dio(
          BaseOptions(
            baseUrl: dio.options.baseUrl,
            connectTimeout: dio.options.connectTimeout,
            receiveTimeout: dio.options.receiveTimeout,
            headers: {
              'accept': '*/*',
              'x-client-type': 'mobile',
              'Content-Type': 'application/json',
            },
          ),
        );
    if (refreshDio == null) {
      _refreshDio.httpClientAdapter = dio.httpClientAdapter;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = authLocalDataSource.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    // Do not attempt to refresh if the request was an auth-related request
    final isAuthEndpoint = path.contains('/auth/login') ||
        path.contains('/auth/refresh') ||
        path.contains('/auth/register') ||
        path.contains('/auth/verify-email') ||
        path.contains('/auth/forgot-password') ||
        path.contains('/auth/reset-password') ||
        path.contains('/auth/google');

    if (statusCode != 401 || isAuthEndpoint) {
      return handler.next(err);
    }

    final currentAccessToken = authLocalDataSource.getAccessToken();
    final requestAuthHeader = err.requestOptions.headers['Authorization']?.toString();

    // If the token was already refreshed by another concurrent request, retry with current token
    if (currentAccessToken != null &&
        requestAuthHeader != null &&
        requestAuthHeader != 'Bearer $currentAccessToken') {
      try {
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $currentAccessToken';
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          return handler.next(e);
        }
        return handler.next(err);
      }
    }

    final refreshToken = authLocalDataSource.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await authLocalDataSource.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      final refreshResponse = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final dynamic data = refreshResponse.data;
      if (data is Map<String, dynamic>) {
        final authResponse = AuthResponseModel.fromJson(data);
        await authLocalDataSource.saveTokens(
          authResponse.accessToken,
          authResponse.refreshToken,
        );

        // Update the header of the original request and retry
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${authResponse.accessToken}';
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } else {
        throw const FormatException('Invalid refresh response structure');
      }
    } catch (e) {
      debugPrint('[AuthInterceptor] Refresh token failed: $e');
      await authLocalDataSource.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }
  }
}

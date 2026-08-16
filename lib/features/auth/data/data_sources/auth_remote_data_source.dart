import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request, {CancelToken? cancelToken});
  Future<UserModel> getMe({CancelToken? cancelToken});
  Future<void> signOut({CancelToken? cancelToken});
  Future<void> register(RegisterRequestModel request, {CancelToken? cancelToken});
  Future<AuthResponseModel> verifyEmail(String token, {CancelToken? cancelToken});
  Future<void> resendVerificationEmail(String email, {CancelToken? cancelToken});
}

AuthResponseModel _parseAuthResponse(Map<String, dynamic> data) => AuthResponseModel.fromJson(data);
UserModel _parseUserModel(Map<String, dynamic> data) => UserModel.fromJson(data);

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(LoginRequestModel request, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
        options: Options(
          headers: {'x-client-type': 'mobile'},
        ),
        cancelToken: cancelToken,
      );
      return await compute(_parseAuthResponse, response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400 || statusCode == 401) {
          throw const InvalidCredentialsException();
        } else if (statusCode == 403) {
          throw const NotVerifiedException();
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException();
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<UserModel> getMe({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/auth/me',
        cancelToken: cancelToken,
        options: Options(
          headers: {'accept': '*/*'},
        ),
      );
      return await compute(_parseUserModel, response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw const ServerException('Session expired');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException('Server error');
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<void> signOut({CancelToken? cancelToken}) async {
    await _dio.post(
      '/auth/sign-out',
      cancelToken: cancelToken,
      options: Options(
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Future<void> register(RegisterRequestModel request, {CancelToken? cancelToken}) async {
    try {
      await _dio.post(
        '/auth/register',
        data: request.toJson(),
        cancelToken: cancelToken,
      );
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 409) {
          throw const ServerException('User already exists');
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<AuthResponseModel> verifyEmail(String token, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/auth/verify-email',
        queryParameters: {'token': token},
        options: Options(
          headers: {
            'accept': '*/*',
            'x-client-type': 'mobile',
          },
        ),
        cancelToken: cancelToken,
      );
      return await compute(_parseAuthResponse, response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400 || statusCode == 401) {
          throw const ServerException('Invalid or expired token');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException('Server error');
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<void> resendVerificationEmail(String email, {CancelToken? cancelToken}) async {
    try {
      await _dio.post(
        '/auth/resend-verification',
        data: {'email': email},
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw const NetworkException();
    }
  }
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/user_session_model.dart';

import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request, {CancelToken? cancelToken});
  Future<AuthResponseModel> loginWithGoogle(String idToken, {String? anonymousSessionId, CancelToken? cancelToken});
  Future<UserModel> getMe({CancelToken? cancelToken});
  Future<void> signOut({CancelToken? cancelToken});
  Future<void> register(RegisterRequestModel request, {CancelToken? cancelToken});
  Future<AuthResponseModel> verifyEmail(String token, {CancelToken? cancelToken});
  Future<void> resendVerificationEmail(String email, {CancelToken? cancelToken});
  Future<String> forgotPassword(String email, {CancelToken? cancelToken});
  Future<String> resetPassword(String token, String newPassword, {CancelToken? cancelToken});
  Future<List<UserSessionModel>> getSessions({CancelToken? cancelToken});
}

AuthResponseModel _parseAuthResponse(Map<String, dynamic> data) => AuthResponseModel.fromJson(data);
UserModel _parseUserModel(Map<String, dynamic> data) => UserModel.fromJson(data);
List<UserSessionModel> _parseUserSessions(List<dynamic> list) =>
    list.map((e) => UserSessionModel.fromJson(e as Map<String, dynamic>)).toList();

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
  Future<AuthResponseModel> loginWithGoogle(
    String idToken, {
    String? anonymousSessionId,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = <String, dynamic>{
        'idToken': idToken,
        if (anonymousSessionId != null && anonymousSessionId.isNotEmpty)
          'anonymousSessionId': anonymousSessionId,
      };

      final response = await _dio.post(
        '/auth/google/mobile',
        data: data,
        options: Options(
          headers: {'x-client-type': 'mobile'},
        ),
        cancelToken: cancelToken,
      );
      return await compute(_parseAuthResponse, response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> && responseData['error'] is Map<String, dynamic>) {
          final error = responseData['error'] as Map<String, dynamic>;
          final message = error['message'] as String?;
          if (message != null && message.isNotEmpty) {
            throw ServerException(message);
          }
        }
        if (statusCode == 400 || statusCode == 401) {
          throw const InvalidCredentialsException('Đăng nhập Google không hợp lệ hoặc đã hết hạn.');
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

  @override
  Future<String> forgotPassword(String email, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
        cancelToken: cancelToken,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'] as String;
      }
      return 'If an account with that email exists, a password reset link has been sent.';
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          throw ServerException(data['message'].toString());
        }
        if (statusCode != null && statusCode >= 500) {
          throw const ServerException();
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<String> resetPassword(String token, String newPassword, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
        },
        cancelToken: cancelToken,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'] as String;
      }
      return 'Password updated successfully. You may now sign in.';
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          throw ServerException(data['message'].toString());
        }
        if (statusCode == 400 || statusCode == 401) {
          throw const ServerException('Token không hợp lệ hoặc đã hết hạn.');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException();
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<List<UserSessionModel>> getSessions({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/auth/sessions',
        cancelToken: cancelToken,
        options: Options(
          headers: {'accept': 'application/json'},
        ),
      );
      final data = response.data;
      if (data is List) {
        return await compute(_parseUserSessions, data);
      }
      return [];
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw const ServerException('Phiên đăng nhập đã hết hạn.');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException('Lỗi máy chủ, vui lòng thử lại sau.');
        }
      }
      throw const NetworkException();
    }
  }
}

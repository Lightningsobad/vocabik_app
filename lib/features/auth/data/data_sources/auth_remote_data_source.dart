import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<UserModel> getMe();
  Future<void> signOut();
  Future<void> register(RegisterRequestModel request);
  Future<void> verifyEmail(String token);
  Future<void> resendVerificationEmail(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      return AuthResponseModel.fromJson(response.data);
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
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(
          headers: {'accept': '*/*'},
        ),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw const ServerException('Phiên đăng nhập hết hạn.');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException('Lỗi máy chủ, vui lòng thử lại sau.');
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<void> signOut() async {
    await _dio.post(
      '/auth/sign-out',
      options: Options(
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Future<void> register(RegisterRequestModel request) async {
    try {
      await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 409) {
          throw const ServerException(); // Or UserAlreadyExistsException if created
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _dio.get(
        '/auth/verify-email',
        queryParameters: {'token': token},
      );
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400 || statusCode == 401) {
          throw const ServerException(); // Or InvalidTokenException
        }
      }
      throw const NetworkException();
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      await _dio.post(
        '/auth/resend-verification',
        data: {'email': email},
      );
    } catch (e) {
      throw const NetworkException();
    }
  }
}

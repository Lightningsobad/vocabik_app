import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/login_request_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<void> signOut();
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
      if (e is DioException && e.response != null) {
        throw Exception(e.response?.data['error']?['message'] ?? 'Login failed');
      }
      throw Exception('Network error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dio.post('/auth/sign-out');
    } catch (e) {
      // Ignore API errors on sign out as we will clear local tokens anyway
    }
  }
}

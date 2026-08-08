import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/update_profile_request_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile(UpdateProfileRequestModel request);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<void> updateProfile(UpdateProfileRequestModel request) async {
    try {
      await _dio.patch(
        '/users/me/profile',
        data: request.toJson(),
      );
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          throw const ServerException('Dữ liệu không hợp lệ.');
        } else if (statusCode == 401) {
          final authHeader = e.requestOptions.headers['Authorization']?.toString() ?? 'null';
          print('========================================');
          print('[DEBUG TOKEN ON 401]:');
          print(authHeader);
          print('========================================');
          throw ServerException('Phiên đăng nhập hết hạn. (Debug Token: $authHeader)');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException('Lỗi máy chủ, vui lòng thử lại sau.');
        }
      }
      throw const NetworkException();
    }
  }
}

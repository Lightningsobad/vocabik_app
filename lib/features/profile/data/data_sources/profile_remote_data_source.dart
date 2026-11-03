import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/update_profile_request_model.dart';
import '../models/update_profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UpdateProfileResponseModel> updateProfile(UpdateProfileRequestModel request);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UpdateProfileResponseModel> updateProfile(UpdateProfileRequestModel request) async {
    try {
      final response = await _dio.patch(
        '/users/me/profile',
        data: request.toJson(),
      );
      if (response.data is Map<String, dynamic>) {
        return UpdateProfileResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      return const UpdateProfileResponseModel();
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          final dynamic data = e.response?.data;
          final message = data is Map && data['message'] != null
              ? data['message'].toString()
              : 'Dữ liệu không hợp lệ.';
          throw ServerException(message);
        } else if (statusCode == 401) {
          throw const ServerException('Phiên đăng nhập hết hạn, vui lòng đăng nhập lại.');
        } else if (statusCode != null && statusCode >= 500) {
          throw const ServerException('Lỗi máy chủ, vui lòng thử lại sau.');
        }
      }
      throw const NetworkException();
    }
  }
}

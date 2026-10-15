import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/block_user_response_model.dart';
import '../models/blocked_user_model.dart';
import '../models/report_request_model.dart';
import '../models/report_response_model.dart';

abstract class ModerationRemoteDataSource {
  Future<ReportResponseModel> submitReport(ReportRequestModel request);
  Future<BlockUserResponseModel> blockUser(String targetUserId);
  Future<BlockUserResponseModel> unblockUser(String targetUserId);
  Future<List<BlockedUserModel>> getBlockedUsers();
}

@LazySingleton(as: ModerationRemoteDataSource)
class ModerationRemoteDataSourceImpl implements ModerationRemoteDataSource {
  final Dio _dio;

  ModerationRemoteDataSourceImpl(this._dio);

  @override
  Future<ReportResponseModel> submitReport(ReportRequestModel request) async {
    try {
      final response = await _dio.post(
        '/reports',
        data: request.toJson(),
      );
      if (response.data is Map<String, dynamic>) {
        return ReportResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      return const ReportResponseModel(
        success: true,
        message: 'Báo cáo của bạn đã được tiếp nhận. Đội ngũ kiểm duyệt sẽ xử lý trong vòng 24 giờ.',
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw const ServerException('Lỗi hệ thống không xác định.');
    }
  }

  @override
  Future<BlockUserResponseModel> blockUser(String targetUserId) async {
    try {
      final response = await _dio.post(
        '/users/$targetUserId/block',
      );
      if (response.data is Map<String, dynamic>) {
        return BlockUserResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      return BlockUserResponseModel(
        success: true,
        targetUserId: targetUserId,
        message: 'Đã chặn người dùng thành công.',
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw const ServerException('Lỗi hệ thống không xác định.');
    }
  }

  @override
  Future<BlockUserResponseModel> unblockUser(String targetUserId) async {
    try {
      final response = await _dio.delete(
        '/users/$targetUserId/block',
      );
      if (response.data is Map<String, dynamic>) {
        return BlockUserResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      return BlockUserResponseModel(
        success: true,
        targetUserId: targetUserId,
        message: 'Đã bỏ chặn người dùng.',
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw const ServerException('Lỗi hệ thống không xác định.');
    }
  }

  @override
  Future<List<BlockedUserModel>> getBlockedUsers() async {
    try {
      final response = await _dio.get('/users/blocked');
      if (response.data is List) {
        return (response.data as List)
            .map((item) => BlockedUserModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw const ServerException('Lỗi hệ thống không xác định.');
    }
  }

  Never _handleDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String? backendMessage;

    if (data is Map && data['message'] != null) {
      backendMessage = data['message'].toString();
    }

    if (statusCode == 400) {
      if (backendMessage == 'CANNOT_REPORT_SELF') {
        throw const ServerException('Bạn không thể tự báo cáo chính mình.');
      } else if (backendMessage == 'CANNOT_BLOCK_SELF') {
        throw const ServerException('Bạn không thể tự chặn chính mình.');
      }
      throw ServerException(backendMessage ?? 'Yêu cầu không hợp lệ.');
    } else if (statusCode == 401) {
      throw const ServerException('Phiên đăng nhập hết hạn, vui lòng đăng nhập lại.');
    } else if (statusCode == 404) {
      throw ServerException(backendMessage ?? 'Người dùng không tồn tại hoặc đã bị xóa.');
    } else if (statusCode != null && statusCode >= 500) {
      throw const ServerException('Lỗi máy chủ, vui lòng thử lại sau.');
    } else if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw const NetworkException();
    }
    throw ServerException(backendMessage ?? 'Đã xảy ra sự cố kết nối.');
  }
}

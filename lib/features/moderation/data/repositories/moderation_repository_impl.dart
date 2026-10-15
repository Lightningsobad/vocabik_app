import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/blocked_user_entity.dart';
import '../../domain/repositories/moderation_repository.dart';
import '../datasources/moderation_remote_data_source.dart';
import '../models/block_user_response_model.dart';
import '../models/report_request_model.dart';
import '../models/report_response_model.dart';

@LazySingleton(as: ModerationRepository)
class ModerationRepositoryImpl implements ModerationRepository {
  final ModerationRemoteDataSource _remoteDataSource;

  ModerationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ReportResponseModel>> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async {
    try {
      final response = await _remoteDataSource.submitReport(
        ReportRequestModel(
          targetType: targetType,
          targetId: targetId,
          reason: reason,
          details: details,
        ),
      );
      return right(response);
    } on NetworkException {
      return left(const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> blockUser(String targetUserId) async {
    try {
      final response = await _remoteDataSource.blockUser(targetUserId);
      return right(response);
    } on NetworkException {
      return left(const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> unblockUser(String targetUserId) async {
    try {
      final response = await _remoteDataSource.unblockUser(targetUserId);
      return right(response);
    } on NetworkException {
      return left(const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, List<BlockedUserEntity>>> getBlockedUsers() async {
    try {
      final response = await _remoteDataSource.getBlockedUsers();
      return right(response);
    } on NetworkException {
      return left(const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }
}

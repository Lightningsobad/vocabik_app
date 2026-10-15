import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/block_user_response_model.dart';
import '../../data/models/report_response_model.dart';
import '../entities/blocked_user_entity.dart';

abstract class ModerationRepository {
  Future<Either<Failure, ReportResponseModel>> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  });

  Future<Either<Failure, BlockUserResponseModel>> blockUser(String targetUserId);

  Future<Either<Failure, BlockUserResponseModel>> unblockUser(String targetUserId);

  Future<Either<Failure, List<BlockedUserEntity>>> getBlockedUsers();
}

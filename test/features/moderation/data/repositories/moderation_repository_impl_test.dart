import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/moderation/data/datasources/moderation_remote_data_source.dart';
import 'package:vocabik_app/features/moderation/data/models/block_user_response_model.dart';
import 'package:vocabik_app/features/moderation/data/models/blocked_user_model.dart';
import 'package:vocabik_app/features/moderation/data/models/report_request_model.dart';
import 'package:vocabik_app/features/moderation/data/models/report_response_model.dart';
import 'package:vocabik_app/features/moderation/data/repositories/moderation_repository_impl.dart';

class FakeModerationRemoteDataSource implements ModerationRemoteDataSource {
  bool shouldThrowNetwork = false;
  bool shouldThrowServer = false;

  @override
  Future<ReportResponseModel> submitReport(ReportRequestModel request) async {
    if (shouldThrowNetwork) throw const NetworkException();
    if (shouldThrowServer) throw const ServerException('Server error');
    return const ReportResponseModel(success: true, reportId: 'rep-1', message: 'Ok');
  }

  @override
  Future<BlockUserResponseModel> blockUser(String targetUserId) async {
    if (shouldThrowNetwork) throw const NetworkException();
    if (shouldThrowServer) throw const ServerException('Server error');
    return BlockUserResponseModel(success: true, targetUserId: targetUserId, message: 'Blocked');
  }

  @override
  Future<BlockUserResponseModel> unblockUser(String targetUserId) async {
    if (shouldThrowNetwork) throw const NetworkException();
    if (shouldThrowServer) throw const ServerException('Server error');
    return BlockUserResponseModel(success: true, targetUserId: targetUserId, message: 'Unblocked');
  }

  @override
  Future<List<BlockedUserModel>> getBlockedUsers() async {
    if (shouldThrowNetwork) throw const NetworkException();
    if (shouldThrowServer) throw const ServerException('Server error');
    return [
      const BlockedUserModel(userId: 'u-1', displayName: 'User 1'),
    ];
  }
}

void main() {
  late FakeModerationRemoteDataSource fakeDataSource;
  late ModerationRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeModerationRemoteDataSource();
    repository = ModerationRepositoryImpl(fakeDataSource);
  });

  group('submitReport', () {
    test('returns Right(ReportResponseModel) on success', () async {
      final result = await repository.submitReport(
        targetType: 'user',
        targetId: 'u-1',
        reason: 'spam',
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (response) => expect(response.reportId, 'rep-1'),
      );
    });

    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.shouldThrowNetwork = true;

      final result = await repository.submitReport(
        targetType: 'user',
        targetId: 'u-1',
        reason: 'spam',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (response) => fail('Should fail'),
      );
    });
  });

  group('blockUser and unblockUser', () {
    test('returns Right on blockUser', () async {
      final result = await repository.blockUser('u-1');
      expect(result.isRight(), true);
    });

    test('returns Right on unblockUser', () async {
      final result = await repository.unblockUser('u-1');
      expect(result.isRight(), true);
    });
  });

  group('getBlockedUsers', () {
    test('returns Right(List<BlockedUserEntity>) on success', () async {
      final result = await repository.getBlockedUsers();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (users) => expect(users.length, 1),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.shouldThrowServer = true;

      final result = await repository.getBlockedUsers();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (users) => fail('Should fail'),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/moderation/data/models/block_user_response_model.dart';
import 'package:vocabik_app/features/moderation/data/models/report_response_model.dart';
import 'package:vocabik_app/features/moderation/domain/entities/blocked_user_entity.dart';
import 'package:vocabik_app/features/moderation/domain/repositories/moderation_repository.dart';
import 'package:vocabik_app/features/moderation/presentation/cubit/blocked_users_cubit.dart';
import 'package:vocabik_app/features/moderation/presentation/cubit/blocked_users_state.dart';

class FakeModerationRepoForCubit implements ModerationRepository {
  bool shouldFailLoad = false;
  bool shouldFailUnblock = false;
  List<BlockedUserEntity> mockUsers = [
    const BlockedUserEntity(userId: 'u-1', displayName: 'User One'),
    const BlockedUserEntity(userId: 'u-2', displayName: 'User Two'),
  ];

  @override
  Future<Either<Failure, List<BlockedUserEntity>>> getBlockedUsers() async {
    if (shouldFailLoad) {
      return left(const ServerFailure('Failed to load'));
    }
    return right(mockUsers);
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> unblockUser(String targetUserId) async {
    if (shouldFailUnblock) {
      return left(const ServerFailure('Failed to unblock'));
    }
    return right(
      BlockUserResponseModel(
        success: true,
        targetUserId: targetUserId,
        message: 'Unblocked',
      ),
    );
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> blockUser(String targetUserId) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ReportResponseModel>> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async =>
      throw UnimplementedError();
}

void main() {
  late FakeModerationRepoForCubit fakeRepo;
  late BlockedUsersCubit cubit;

  setUp(() {
    fakeRepo = FakeModerationRepoForCubit();
    cubit = BlockedUsersCubit(fakeRepo);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has status initial and empty users', () {
    expect(cubit.state.status, BlockedUsersStatus.initial);
    expect(cubit.state.users, isEmpty);
  });

  test('loadBlockedUsers emits loading then success', () async {
    final expectedStates = [
      const BlockedUsersState(status: BlockedUsersStatus.loading),
      BlockedUsersState(
        status: BlockedUsersStatus.success,
        users: fakeRepo.mockUsers,
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadBlockedUsers();
  });

  test('loadBlockedUsers emits loading then failure on error', () async {
    fakeRepo.shouldFailLoad = true;

    final expectedStates = [
      const BlockedUsersState(status: BlockedUsersStatus.loading),
      const BlockedUsersState(
        status: BlockedUsersStatus.failure,
        errorMessage: 'Failed to load',
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadBlockedUsers();
  });

  test('unblockUser removes user optimistically and succeeds', () async {
    await cubit.loadBlockedUsers();

    expect(cubit.state.users.length, 2);

    final success = await cubit.unblockUser('u-1');

    expect(success, true);
    expect(cubit.state.users.length, 1);
    expect(cubit.state.users.first.userId, 'u-2');
  });

  test('unblockUser rolls back on failure', () async {
    await cubit.loadBlockedUsers();

    fakeRepo.shouldFailUnblock = true;

    final success = await cubit.unblockUser('u-1');

    expect(success, false);
    // Rolled back to 2 users
    expect(cubit.state.users.length, 2);
    expect(cubit.state.errorMessage, 'Failed to unblock');
  });
}

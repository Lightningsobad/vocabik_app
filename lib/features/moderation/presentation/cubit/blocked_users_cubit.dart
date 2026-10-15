import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/blocked_user_entity.dart';
import '../../domain/repositories/moderation_repository.dart';
import 'blocked_users_state.dart';

@injectable
class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  final ModerationRepository _moderationRepository;

  BlockedUsersCubit(this._moderationRepository)
      : super(const BlockedUsersState());

  @override
  void emit(BlockedUsersState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> loadBlockedUsers() async {
    if (isClosed) return;
    emit(state.copyWith(status: BlockedUsersStatus.loading, errorMessage: null));

    final result = await _moderationRepository.getBlockedUsers();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          status: BlockedUsersStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (users) {
        if (isClosed) return;
        emit(state.copyWith(
          status: BlockedUsersStatus.success,
          users: users,
        ));
      },
    );
  }

  Future<bool> unblockUser(String userId) async {
    if (isClosed) return false;

    // Save previous list for optimistic rollback
    final previousUsers = List<BlockedUserEntity>.from(state.users);
    final updatedUsers = previousUsers.where((u) => u.userId != userId).toList();

    emit(state.copyWith(
      users: updatedUsers,
      actionLoadingUserId: userId,
      errorMessage: null,
    ));

    final result = await _moderationRepository.unblockUser(userId);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        if (isClosed) return false;
        // Rollback optimistic update
        emit(state.copyWith(
          users: previousUsers,
          clearActionLoading: true,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        if (isClosed) return false;
        emit(state.copyWith(clearActionLoading: true));
        return true;
      },
    );
  }
}

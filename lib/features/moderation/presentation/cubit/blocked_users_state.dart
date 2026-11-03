import 'package:equatable/equatable.dart';
import '../../domain/entities/blocked_user_entity.dart';

enum BlockedUsersStatus { initial, loading, success, failure }

class BlockedUsersState extends Equatable {
  final BlockedUsersStatus status;
  final List<BlockedUserEntity> users;
  final String? errorMessage;
  final String? actionLoadingUserId;

  const BlockedUsersState({
    this.status = BlockedUsersStatus.initial,
    this.users = const [],
    this.errorMessage,
    this.actionLoadingUserId,
  });

  BlockedUsersState copyWith({
    BlockedUsersStatus? status,
    List<BlockedUserEntity>? users,
    String? errorMessage,
    String? actionLoadingUserId,
    bool clearActionLoading = false,
  }) {
    return BlockedUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
      actionLoadingUserId: clearActionLoading
          ? null
          : (actionLoadingUserId ?? this.actionLoadingUserId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        users,
        errorMessage,
        actionLoadingUserId,
      ];
}

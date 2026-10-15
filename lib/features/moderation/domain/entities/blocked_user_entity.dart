import 'package:equatable/equatable.dart';

class BlockedUserEntity extends Equatable {
  final String userId;
  final String displayName;
  final DateTime? blockedAt;

  const BlockedUserEntity({
    required this.userId,
    required this.displayName,
    this.blockedAt,
  });

  @override
  List<Object?> get props => [userId, displayName, blockedAt];
}

import 'package:equatable/equatable.dart';

class LeaderboardEntryEntity extends Equatable {
  final int rank;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int xp;
  final bool isCurrentUser;

  const LeaderboardEntryEntity({
    required this.rank,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.xp,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
        rank,
        userId,
        displayName,
        avatarUrl,
        xp,
        isCurrentUser,
      ];
}

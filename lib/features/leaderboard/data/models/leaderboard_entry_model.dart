import '../../domain/entities/leaderboard_entry_entity.dart';

class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.rank,
    required super.userId,
    required super.displayName,
    super.avatarUrl,
    required super.xp,
    super.isCurrentUser = false,
  });

  factory LeaderboardEntryModel.fromJson(
    Map<String, dynamic> json, {
    int? defaultRank,
    String? currentUserId,
  }) {
    final userId = json['userId'] as String? ?? json['id'] as String? ?? '';
    final isCurrent = json['isCurrentUser'] as bool? ??
        (currentUserId != null && currentUserId.isNotEmpty && userId == currentUserId);

    return LeaderboardEntryModel(
      rank: json['rank'] as int? ?? defaultRank ?? 0,
      userId: userId,
      displayName: json['displayName'] as String? ?? json['name'] as String? ?? 'User',
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar'] as String?,
      xp: json['xp'] as int? ?? json['score'] as int? ?? 0,
      isCurrentUser: isCurrent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'xp': xp,
      'isCurrentUser': isCurrentUser,
    };
  }

  LeaderboardEntryModel copyWith({
    int? rank,
    String? userId,
    String? displayName,
    String? avatarUrl,
    int? xp,
    bool? isCurrentUser,
  }) {
    return LeaderboardEntryModel(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}

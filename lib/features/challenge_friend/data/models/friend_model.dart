import '../../domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity {
  const FriendModel({
    required super.userId,
    required super.displayName,
    super.avatarUrl,
    super.tier,
    super.cefrLevel,
    super.lastActive,
    super.friendedAt,
    super.xp,
    super.streak,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return FriendModel(
      userId: json['userId'] as String? ?? json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ??
          json['name'] as String? ??
          'Friend',
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar'] as String?,
      tier: json['tier'] as String?,
      cefrLevel: json['cefrLevel'] as String?,
      lastActive: parseDate(json['lastActive']),
      friendedAt: parseDate(json['friendedAt']),
      xp: json['xp'] as int? ?? json['score'] as int?,
      streak: json['streak'] as int? ?? json['streakDays'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'tier': tier,
      'cefrLevel': cefrLevel,
      'lastActive': lastActive?.toIso8601String(),
      'friendedAt': friendedAt?.toIso8601String(),
      'xp': xp,
      'streak': streak,
    };
  }

  FriendEntity toEntity() {
    return FriendEntity(
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
      tier: tier,
      cefrLevel: cefrLevel,
      lastActive: lastActive,
      friendedAt: friendedAt,
      xp: xp,
      streak: streak,
    );
  }
}

import '../../domain/entities/blocked_user_entity.dart';

class BlockedUserModel extends BlockedUserEntity {
  const BlockedUserModel({
    required super.userId,
    required super.displayName,
    super.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      userId: json['userId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      blockedAt: json['blockedAt'] != null
          ? DateTime.tryParse(json['blockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'displayName': displayName,
    if (blockedAt != null) 'blockedAt': blockedAt!.toIso8601String(),
  };
}

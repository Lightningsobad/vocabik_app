import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required super.tier,
    required super.emailVerified,
    super.role,
    super.cefrLevel,
    super.hintMode,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final idVal = (json['userId'] ?? json['id'] ?? '') as String;
    return UserModel(
      id: idVal,
      email: (json['email'] ?? '') as String,
      displayName: (json['displayName'] ?? '') as String,
      tier: (json['tier'] ?? 'free') as String,
      emailVerified: (json['emailVerified'] ?? false) as bool,
      role: json['role'] as String?,
      cefrLevel: json['cefrLevel'] as String?,
      hintMode: json['hintMode'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'tier': tier,
      'emailVerified': emailVerified,
      'role': role,
      'cefrLevel': cefrLevel,
      'hintMode': hintMode,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User user) {
    if (user is UserModel) return user;
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      tier: user.tier,
      emailVerified: user.emailVerified,
      role: user.role,
      cefrLevel: user.cefrLevel,
      hintMode: user.hintMode,
      createdAt: user.createdAt,
    );
  }
}

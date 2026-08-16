import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required super.tier,
    required super.emailVerified,
    super.role,
    super.subscription,
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
      subscription: json['subscription'] != null ? json['subscription'] as Map<String, dynamic> : null,
      cefrLevel: json['cefrLevel'] as String?,
      hintMode: json['hintMode'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}

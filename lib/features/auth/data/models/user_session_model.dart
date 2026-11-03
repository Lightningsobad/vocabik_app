import '../../domain/entities/user_session.dart';

class UserSessionModel extends UserSession {
  const UserSessionModel({
    required super.id,
    required super.device,
    required super.ip,
    super.createdAt,
    super.lastActive,
    required super.current,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      id: (json['id'] ?? '') as String,
      device: (json['device'] ?? '') as String,
      ip: (json['ip'] ?? '') as String,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      lastActive: json['lastActive'] != null
          ? DateTime.tryParse(json['lastActive'].toString())
          : null,
      current: (json['current'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device': device,
      'ip': ip,
      'createdAt': createdAt?.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
      'current': current,
    };
  }
}

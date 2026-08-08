import 'user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? tokens;
    if (json['tokens'] is Map<String, dynamic>) {
      tokens = json['tokens'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic> && json['data']['tokens'] is Map<String, dynamic>) {
      tokens = json['data']['tokens'] as Map<String, dynamic>;
    }

    final accessToken = (tokens?['accessToken'] ??
        json['accessToken'] ??
        json['token'] ??
        (json['data'] is Map<String, dynamic> ? json['data']['accessToken'] ?? json['data']['token'] : null) ??
        '') as String;

    final refreshToken = (tokens?['refreshToken'] ??
        json['refreshToken'] ??
        (json['data'] is Map<String, dynamic> ? json['data']['refreshToken'] : null) ??
        '') as String;

    final userJson = (json['user'] is Map<String, dynamic>)
        ? json['user'] as Map<String, dynamic>
        : (json['data'] is Map<String, dynamic> && json['data']['user'] is Map<String, dynamic>)
            ? json['data']['user'] as Map<String, dynamic>
            : json;

    return AuthResponseModel(
      user: UserModel.fromJson(userJson),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

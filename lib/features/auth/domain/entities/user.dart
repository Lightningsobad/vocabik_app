import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String tier;
  final bool emailVerified;
  final String? role;
  final Map<String, dynamic>? subscription;
  final String? cefrLevel;
  final String? hintMode;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.tier,
    required this.emailVerified,
    this.role,
    this.subscription,
    this.cefrLevel,
    this.hintMode,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        tier,
        emailVerified,
        role,
        subscription,
        cefrLevel,
        hintMode,
        createdAt,
      ];
}

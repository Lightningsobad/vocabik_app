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

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? tier,
    bool? emailVerified,
    String? role,
    Map<String, dynamic>? subscription,
    String? cefrLevel,
    String? hintMode,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      tier: tier ?? this.tier,
      emailVerified: emailVerified ?? this.emailVerified,
      role: role ?? this.role,
      subscription: subscription ?? this.subscription,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      hintMode: hintMode ?? this.hintMode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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

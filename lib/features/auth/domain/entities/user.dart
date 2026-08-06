import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String tier;
  final bool emailVerified;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.tier,
    required this.emailVerified,
  });

  @override
  List<Object?> get props => [id, email, displayName, tier, emailVerified];
}

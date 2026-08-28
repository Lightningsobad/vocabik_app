import 'package:equatable/equatable.dart';

class BadgeEntity extends Equatable {
  final String code;
  final String displayName;
  final String description;
  final String? iconRef;
  final bool locked;
  final DateTime? awardedAt;

  const BadgeEntity({
    required this.code,
    required this.displayName,
    required this.description,
    this.iconRef,
    required this.locked,
    this.awardedAt,
  });

  @override
  List<Object?> get props => [
        code,
        displayName,
        description,
        iconRef,
        locked,
        awardedAt,
      ];
}

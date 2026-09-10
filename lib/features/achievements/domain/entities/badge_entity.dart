import 'package:equatable/equatable.dart';

class BadgeProgressEntity extends Equatable {
  final int current;
  final int target;

  const BadgeProgressEntity({
    required this.current,
    required this.target,
  });

  double get percentage =>
      target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

  @override
  List<Object?> get props => [current, target];
}

class BadgeEntity extends Equatable {
  final String code;
  final String displayName;
  final String description;
  final String? category;
  final String? iconRef;
  final bool locked;
  final DateTime? awardedAt;
  final BadgeProgressEntity? progress;

  const BadgeEntity({
    required this.code,
    required this.displayName,
    required this.description,
    this.category,
    this.iconRef,
    required this.locked,
    this.awardedAt,
    this.progress,
  });

  @override
  List<Object?> get props => [
        code,
        displayName,
        description,
        category,
        iconRef,
        locked,
        awardedAt,
        progress,
      ];
}

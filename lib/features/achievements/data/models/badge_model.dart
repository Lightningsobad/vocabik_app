import '../../domain/entities/badge_entity.dart';

class BadgeModel extends BadgeEntity {
  const BadgeModel({
    required super.code,
    required super.displayName,
    required super.description,
    super.iconRef,
    required super.locked,
    super.awardedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      code: json['code'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconRef: json['iconRef'] as String?,
      locked: json['locked'] as bool? ?? true,
      awardedAt: json['awardedAt'] != null
          ? DateTime.tryParse(json['awardedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'displayName': displayName,
      'description': description,
      'iconRef': iconRef,
      'locked': locked,
      'awardedAt': awardedAt?.toIso8601String(),
    };
  }
}

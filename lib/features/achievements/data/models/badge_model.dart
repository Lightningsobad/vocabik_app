import '../../domain/entities/badge_entity.dart';

class BadgeProgressModel extends BadgeProgressEntity {
  const BadgeProgressModel({
    required super.current,
    required super.target,
  });

  factory BadgeProgressModel.fromJson(Map<String, dynamic> json) {
    return BadgeProgressModel(
      current: (json['current'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'target': target,
    };
  }
}

class BadgeModel extends BadgeEntity {
  const BadgeModel({
    required super.code,
    required super.displayName,
    required super.description,
    super.category,
    super.iconRef,
    required super.locked,
    super.awardedAt,
    super.progress,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      code: json['code'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String?,
      iconRef: json['iconRef'] as String?,
      locked: json['locked'] as bool? ?? true,
      awardedAt: json['awardedAt'] != null
          ? DateTime.tryParse(json['awardedAt'] as String)
          : null,
      progress: json['progress'] != null && json['progress'] is Map<String, dynamic>
          ? BadgeProgressModel.fromJson(json['progress'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'displayName': displayName,
      'description': description,
      'category': category,
      'iconRef': iconRef,
      'locked': locked,
      'awardedAt': awardedAt?.toIso8601String(),
      'progress': progress != null && progress is BadgeProgressModel
          ? (progress as BadgeProgressModel).toJson()
          : null,
    };
  }
}

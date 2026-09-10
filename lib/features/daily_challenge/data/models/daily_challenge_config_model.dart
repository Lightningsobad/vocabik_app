import '../../domain/entities/daily_challenge_config_entity.dart';

class DailyChallengeResponseModel extends DailyChallengeResponseEntity {
  const DailyChallengeResponseModel({
    required super.challengeConfigured,
    super.config,
    super.participantCount = 0,
    super.resetAt,
    super.userResult,
  });

  factory DailyChallengeResponseModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeResponseModel(
      challengeConfigured: json['challengeConfigured'] as bool? ?? false,
      config: json['config'] != null
          ? DailyChallengeConfigModel.fromJson(
              json['config'] as Map<String, dynamic>)
          : null,
      participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
      resetAt: json['resetAt'] != null
          ? DateTime.tryParse(json['resetAt'] as String)
          : null,
      userResult: json['userResult'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengeConfigured': challengeConfigured,
      'config': (config as DailyChallengeConfigModel?)?.toJson(),
      'participantCount': participantCount,
      'resetAt': resetAt?.toIso8601String(),
      'userResult': userResult,
    };
  }
}

class DailyChallengeConfigModel extends DailyChallengeConfigEntity {
  const DailyChallengeConfigModel({
    required super.id,
    required super.challengeDate,
    required super.videoSlug,
    required super.videoTitle,
    required super.thumbnailUrl,
    super.category = '',
    super.cefrLevel = '',
    super.author = '',
    super.durationSeconds = 0,
    required super.exerciseVersion,
    super.createdAt,
  });

  factory DailyChallengeConfigModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeConfigModel(
      id: json['id'] as String? ?? '',
      challengeDate: json['challengeDate'] as String? ?? '',
      videoSlug: json['videoSlug'] as String? ?? '',
      videoTitle: (json['videoTitle'] as String? ?? '').trim(),
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      cefrLevel: json['cefrLevel'] as String? ?? '',
      author: (json['author'] as String? ?? '').trim(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      exerciseVersion: json['exerciseVersion'] as String? ?? 'v1',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeDate': challengeDate,
      'videoSlug': videoSlug,
      'videoTitle': videoTitle,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'cefrLevel': cefrLevel,
      'author': author,
      'durationSeconds': durationSeconds,
      'exerciseVersion': exerciseVersion,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

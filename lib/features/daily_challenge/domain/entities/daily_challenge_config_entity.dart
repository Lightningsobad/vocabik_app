import 'package:equatable/equatable.dart';

class DailyChallengeResponseEntity extends Equatable {
  final bool challengeConfigured;
  final DailyChallengeConfigEntity? config;
  final int participantCount;
  final DateTime? resetAt;
  final Map<String, dynamic>? userResult;

  const DailyChallengeResponseEntity({
    required this.challengeConfigured,
    this.config,
    this.participantCount = 0,
    this.resetAt,
    this.userResult,
  });

  @override
  List<Object?> get props => [
        challengeConfigured,
        config,
        participantCount,
        resetAt,
        userResult,
      ];
}

class DailyChallengeConfigEntity extends Equatable {
  final String id;
  final String challengeDate;
  final String videoSlug;
  final String videoTitle;
  final String thumbnailUrl;
  final String exerciseVersion;
  final DateTime? createdAt;

  const DailyChallengeConfigEntity({
    required this.id,
    required this.challengeDate,
    required this.videoSlug,
    required this.videoTitle,
    required this.thumbnailUrl,
    required this.exerciseVersion,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        challengeDate,
        videoSlug,
        videoTitle,
        thumbnailUrl,
        exerciseVersion,
        createdAt,
      ];
}

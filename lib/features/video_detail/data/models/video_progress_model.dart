import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';

class VideoProgressModel {
  final String videoId;
  final String status;
  final int totalAttempts;
  final int bestScore;
  final String cefrLevel;
  final int accuracyScore;
  final DateTime? completedAt;

  VideoProgressModel({
    required this.videoId,
    required this.status,
    required this.totalAttempts,
    required this.bestScore,
    required this.cefrLevel,
    required this.accuracyScore,
    this.completedAt,
  });

  factory VideoProgressModel.fromJson(Map<String, dynamic> json) {
    final lastAttempt = json['lastAttempt'] as Map<String, dynamic>?;
    return VideoProgressModel(
      videoId: json['videoId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalAttempts: (json['totalAttempts'] as num?)?.toInt() ?? 0,
      bestScore: (json['bestScore'] as num?)?.toInt() ?? 0,
      cefrLevel: lastAttempt?['cefrLevel'] as String? ?? '',
      accuracyScore: (lastAttempt?['accuracyScore'] as num?)?.toInt() ?? 0,
      completedAt: lastAttempt?['completedAt'] != null
          ? DateTime.tryParse(lastAttempt!['completedAt'] as String)
          : null,
    );
  }

  VideoProgressEntity toEntity() {
    return VideoProgressEntity(
      videoId: videoId,
      status: status,
      totalAttempts: totalAttempts,
      bestScore: bestScore,
      cefrLevel: cefrLevel,
      accuracyScore: accuracyScore,
      completedAt: completedAt,
    );
  }
}


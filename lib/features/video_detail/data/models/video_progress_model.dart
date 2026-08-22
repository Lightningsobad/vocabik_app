import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';

class VideoProgressModel {
  final String videoTitle;
  final String cefrLevel;
  final int accuracyScore;
  final DateTime completedAt;

  VideoProgressModel({
    required this.videoTitle,
    required this.cefrLevel,
    required this.accuracyScore,
    required this.completedAt,
  });

  factory VideoProgressModel.fromJson(Map<String, dynamic> json) {
    return VideoProgressModel(
      videoTitle: json['videoTitle'] as String? ?? '',
      cefrLevel: json['cefrLevel'] as String? ?? '',
      accuracyScore: (json['accuracyScore'] as num?)?.toInt() ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  VideoProgressEntity toEntity() {
    return VideoProgressEntity(
      videoTitle: videoTitle,
      cefrLevel: cefrLevel,
      accuracyScore: accuracyScore,
      completedAt: completedAt,
    );
  }
}

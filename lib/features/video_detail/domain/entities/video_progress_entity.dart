import 'package:equatable/equatable.dart';

class VideoProgressEntity extends Equatable {
  final String videoId;
  final String status;
  final int totalAttempts;
  final int bestScore;
  final String cefrLevel;
  final int accuracyScore;
  final DateTime? completedAt;

  const VideoProgressEntity({
    required this.videoId,
    required this.status,
    required this.totalAttempts,
    required this.bestScore,
    required this.cefrLevel,
    required this.accuracyScore,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        videoId,
        status,
        totalAttempts,
        bestScore,
        cefrLevel,
        accuracyScore,
        completedAt,
      ];
}


import 'package:equatable/equatable.dart';

class VideoProgressEntity extends Equatable {
  final String videoTitle;
  final String cefrLevel;
  final int accuracyScore;
  final DateTime completedAt;

  const VideoProgressEntity({
    required this.videoTitle,
    required this.cefrLevel,
    required this.accuracyScore,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [videoTitle, cefrLevel, accuracyScore, completedAt];
}

import 'package:equatable/equatable.dart';

class ScoreCardRequest extends Equatable {
  final String videoId;
  final String cefrLevel;
  final int accuracyScore;

  const ScoreCardRequest({
    required this.videoId,
    required this.cefrLevel,
    required this.accuracyScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'cefrLevel': cefrLevel,
      'accuracyScore': accuracyScore,
    };
  }

  @override
  List<Object?> get props => [videoId, cefrLevel, accuracyScore];
}

import 'package:equatable/equatable.dart';

class PersonalizedSlotEntity extends Equatable {
  final int position;
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String youtubeVideoId;
  final String cefrLevel;

  const PersonalizedSlotEntity({
    required this.position,
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.youtubeVideoId,
    required this.cefrLevel,
  });

  @override
  List<Object?> get props => [
        position,
        videoId,
        title,
        thumbnailUrl,
        youtubeVideoId,
        cefrLevel,
      ];
}

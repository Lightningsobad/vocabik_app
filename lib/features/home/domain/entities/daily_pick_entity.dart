import 'package:equatable/equatable.dart';

class DailyPickEntity extends Equatable {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String cefrLevel;
  final String playerUrl;
  final String artist;
  final int durationSeconds;
  final String category;
  final int practiced;

  const DailyPickEntity({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.cefrLevel,
    required this.playerUrl,
    this.artist = '',
    this.durationSeconds = 0,
    this.category = '',
    this.practiced = 0,
  });

  @override
  List<Object?> get props => [
        videoId,
        title,
        thumbnailUrl,
        cefrLevel,
        playerUrl,
        artist,
        durationSeconds,
        category,
        practiced,
      ];
}

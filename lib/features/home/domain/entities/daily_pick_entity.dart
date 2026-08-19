import 'package:equatable/equatable.dart';

class DailyPickEntity extends Equatable {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String cefrLevel;
  final String playerUrl;

  const DailyPickEntity({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.cefrLevel,
    required this.playerUrl,
  });

  @override
  List<Object?> get props => [
        videoId,
        title,
        thumbnailUrl,
        cefrLevel,
        playerUrl,
      ];
}

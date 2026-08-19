import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';

class DailyPickModel extends DailyPickEntity {
  const DailyPickModel({
    required super.videoId,
    required super.title,
    required super.thumbnailUrl,
    required super.cefrLevel,
    required super.playerUrl,
  });

  factory DailyPickModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json.containsKey('dailyPick') && json['dailyPick'] is Map<String, dynamic>
        ? json['dailyPick'] as Map<String, dynamic>
        : json;

    return DailyPickModel(
      videoId: data['videoId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      cefrLevel: data['cefrLevel'] as String? ?? '',
      playerUrl: data['playerUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'cefrLevel': cefrLevel,
      'playerUrl': playerUrl,
    };
  }
}

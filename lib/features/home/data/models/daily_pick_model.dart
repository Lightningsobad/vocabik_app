import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';

class DailyPickModel extends DailyPickEntity {
  const DailyPickModel({
    required super.videoId,
    required super.title,
    required super.thumbnailUrl,
    required super.cefrLevel,
    required super.playerUrl,
    super.artist,
    super.durationSeconds,
    super.category,
    super.practiced,
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
      artist: data['artist'] as String? ?? '',
      durationSeconds: (data['durationSeconds'] as num?)?.toInt() ?? 0,
      category: data['category'] as String? ?? '',
      practiced: (data['practiced'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'cefrLevel': cefrLevel,
      'playerUrl': playerUrl,
      'artist': artist,
      'durationSeconds': durationSeconds,
      'category': category,
      'practiced': practiced,
    };
  }
}

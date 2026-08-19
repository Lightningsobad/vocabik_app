import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';

class PersonalizedSlotModel extends PersonalizedSlotEntity {
  const PersonalizedSlotModel({
    required super.position,
    required super.videoId,
    required super.title,
    required super.thumbnailUrl,
    required super.youtubeVideoId,
    required super.cefrLevel,
  });

  factory PersonalizedSlotModel.fromJson(Map<String, dynamic> json) {
    return PersonalizedSlotModel(
      position: json['position'] as int? ?? 0,
      videoId: json['videoId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      youtubeVideoId: json['youtubeVideoId'] as String? ?? '',
      cefrLevel: json['cefrLevel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'videoId': videoId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'youtubeVideoId': youtubeVideoId,
      'cefrLevel': cefrLevel,
    };
  }
}

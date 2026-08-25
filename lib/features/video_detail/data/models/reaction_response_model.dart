import 'package:vocabik_app/features/video_detail/domain/entities/reaction_result_entity.dart';

class ReactionResponseModel {
  final bool created;
  final Map<String, int> counts;

  ReactionResponseModel({
    required this.created,
    required this.counts,
  });

  factory ReactionResponseModel.fromJson(Map<String, dynamic> json) {
    final countsMap = <String, int>{};
    if (json['counts'] is Map) {
      final rawCounts = json['counts'] as Map;
      rawCounts.forEach((key, value) {
        if (value is num) {
          countsMap[key.toString()] = value.toInt();
        }
      });
    }

    return ReactionResponseModel(
      created: json['created'] as bool? ?? false,
      counts: countsMap,
    );
  }

  ReactionResultEntity toEntity() {
    return ReactionResultEntity(
      created: created,
      counts: counts,
    );
  }
}

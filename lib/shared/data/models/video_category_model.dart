import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';

class VideoCategoryModel {
  final String slug;
  final String label;
  final String shortLabel;
  final Map<String, String> labels;
  final Map<String, String> shortLabels;
  final int sortOrder;

  const VideoCategoryModel({
    required this.slug,
    required this.label,
    required this.shortLabel,
    this.labels = const {},
    this.shortLabels = const {},
    this.sortOrder = 0,
  });

  factory VideoCategoryModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> parseStringMap(dynamic raw) {
      if (raw is! Map) return const {};
      final result = <String, String>{};
      for (final entry in raw.entries) {
        final value = entry.value;
        if (value is String && value.isNotEmpty) {
          result[entry.key.toString().toLowerCase()] = value;
        }
      }
      return result;
    }

    final label = (json['label'] as String?) ?? '';
    final shortLabel = (json['shortLabel'] as String?) ?? label;

    return VideoCategoryModel(
      slug: (json['slug'] as String?) ?? '',
      label: label,
      shortLabel: shortLabel,
      labels: parseStringMap(json['labels']),
      shortLabels: parseStringMap(json['shortLabels']),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  VideoCategoryEntity toEntity() {
    return VideoCategoryEntity(
      slug: slug,
      label: label,
      shortLabel: shortLabel,
      labels: labels,
      shortLabels: shortLabels,
      sortOrder: sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'label': label,
      'shortLabel': shortLabel,
      'labels': labels,
      'shortLabels': shortLabels,
      'sortOrder': sortOrder,
    };
  }
}

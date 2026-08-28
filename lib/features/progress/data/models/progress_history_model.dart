import '../../domain/entities/progress_history.dart';

class ProgressHistoryItemModel extends ProgressHistoryItem {
  const ProgressHistoryItemModel({
    required super.videoTitle,
    required super.cefrLevel,
    required super.accuracyScore,
    required super.completedAt,
  });

  factory ProgressHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ProgressHistoryItemModel(
      videoTitle: json['videoTitle'] as String? ?? '',
      cefrLevel: json['cefrLevel'] as String? ?? 'A1',
      accuracyScore: json['accuracyScore'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ProgressHistoryModel extends ProgressHistory {
  const ProgressHistoryModel({
    required super.items,
  });

  factory ProgressHistoryModel.fromJson(Map<String, dynamic> json) {
    return ProgressHistoryModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  ProgressHistoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

import 'package:equatable/equatable.dart';

class VideoCategoryEntity extends Equatable {
  final String slug;
  final String label;
  final String shortLabel;
  final Map<String, String> labels;
  final Map<String, String> shortLabels;
  final int sortOrder;

  const VideoCategoryEntity({
    required this.slug,
    required this.label,
    required this.shortLabel,
    this.labels = const {},
    this.shortLabels = const {},
    this.sortOrder = 0,
  });

  String localizedShortLabel(String languageCode) {
    final normalized = languageCode.toLowerCase();
    final shortMatch = shortLabels[normalized];
    if (shortMatch != null && shortMatch.isNotEmpty) return shortMatch;
    final labelMatch = labels[normalized];
    if (labelMatch != null && labelMatch.isNotEmpty) return labelMatch;
    if (shortLabel.isNotEmpty) return shortLabel;
    return label;
  }

  @override
  List<Object?> get props => [
        slug,
        label,
        shortLabel,
        labels,
        shortLabels,
        sortOrder,
      ];
}

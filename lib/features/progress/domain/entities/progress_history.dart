import 'package:equatable/equatable.dart';

class ProgressHistoryItem extends Equatable {
  final String videoTitle;
  final String cefrLevel;
  final int accuracyScore;
  final DateTime completedAt;

  const ProgressHistoryItem({
    required this.videoTitle,
    required this.cefrLevel,
    required this.accuracyScore,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [
        videoTitle,
        cefrLevel,
        accuracyScore,
        completedAt,
      ];
}

class ProgressHistory extends Equatable {
  final List<ProgressHistoryItem> items;

  const ProgressHistory({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}

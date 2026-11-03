import 'package:equatable/equatable.dart';
import 'word_entity.dart';

class NotebookWordsResult extends Equatable {
  final List<WordEntity> words;
  final int total;
  final String? nextCursor;

  const NotebookWordsResult({
    required this.words,
    required this.total,
    this.nextCursor,
  });

  @override
  List<Object?> get props => [words, total, nextCursor];
}

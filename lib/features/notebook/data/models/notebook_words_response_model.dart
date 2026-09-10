import '../../domain/entities/notebook_words_result.dart';
import 'word_model.dart';

class NotebookWordsResponseModel extends NotebookWordsResult {
  const NotebookWordsResponseModel({
    required super.words,
    required super.total,
    super.nextCursor,
  });

  factory NotebookWordsResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] ?? json['words'] ?? json['items'] ?? [];
    final words = (list is List)
        ? list
            .whereType<Map<String, dynamic>>()
            .map((e) => WordModel.fromJson(e))
            .toList()
        : <WordModel>[];
    final total = json['total'] as int? ?? words.length;
    final nextCursor = json['nextCursor'] as String?;

    return NotebookWordsResponseModel(
      words: words,
      total: total,
      nextCursor: nextCursor,
    );
  }
}

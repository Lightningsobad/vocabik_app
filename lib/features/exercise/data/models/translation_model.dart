import 'package:vocabik_app/features/exercise/domain/entities/translation_entity.dart';

class TranslationModel extends TranslationEntity {
  const TranslationModel({
    required super.lineIndex,
    required super.language,
    required super.text,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      lineIndex: json['line_index'] as int? ?? 0,
      language: json['language'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line_index': lineIndex,
      'language': language,
      'text': text,
    };
  }

  TranslationEntity toEntity() {
    return TranslationEntity(
      lineIndex: lineIndex,
      language: language,
      text: text,
    );
  }
}

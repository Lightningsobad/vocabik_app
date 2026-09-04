import '../../domain/entities/word_entity.dart';

class WordModel extends WordEntity {
  const WordModel({
    required super.id,
    required super.word,
    required super.ipa,
    required super.definitionVi,
    required super.exampleSentence,
    super.videoSourceId,
    super.videoSourceTitle,
    required super.cefrLevel,
    required super.savedAt,
    required super.needsReview,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      ipa: json['ipa'] as String? ?? '',
      definitionVi: json['definition_vi'] as String? ?? json['definition'] as String? ?? '',
      exampleSentence: json['example_sentence'] as String? ?? json['example'] as String? ?? '',
      videoSourceId: json['video_source_id'] as String?,
      videoSourceTitle: json['video_source_title'] as String?,
      cefrLevel: json['cefr_level'] as String? ?? 'A1',
      savedAt: json['saved_at'] != null
          ? DateTime.tryParse(json['saved_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      needsReview: json['needs_review'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'ipa': ipa,
      'definition_vi': definitionVi,
      'example_sentence': exampleSentence,
      'video_source_id': videoSourceId,
      'video_source_title': videoSourceTitle,
      'cefr_level': cefrLevel,
      'saved_at': savedAt.toIso8601String(),
      'needs_review': needsReview,
    };
  }
}

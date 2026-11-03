import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  final String id;
  final String word;
  final String ipa;
  final String definitionVi;
  final String exampleSentence;
  final String? videoSourceId;
  final String? videoSourceTitle;
  final String cefrLevel;
  final DateTime savedAt;
  final bool needsReview;

  const WordEntity({
    required this.id,
    required this.word,
    required this.ipa,
    required this.definitionVi,
    required this.exampleSentence,
    this.videoSourceId,
    this.videoSourceTitle,
    required this.cefrLevel,
    required this.savedAt,
    required this.needsReview,
  });

  WordEntity copyWith({
    String? id,
    String? word,
    String? ipa,
    String? definitionVi,
    String? exampleSentence,
    String? videoSourceId,
    String? videoSourceTitle,
    String? cefrLevel,
    DateTime? savedAt,
    bool? needsReview,
  }) {
    return WordEntity(
      id: id ?? this.id,
      word: word ?? this.word,
      ipa: ipa ?? this.ipa,
      definitionVi: definitionVi ?? this.definitionVi,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      videoSourceId: videoSourceId ?? this.videoSourceId,
      videoSourceTitle: videoSourceTitle ?? this.videoSourceTitle,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      savedAt: savedAt ?? this.savedAt,
      needsReview: needsReview ?? this.needsReview,
    );
  }

  @override
  List<Object?> get props => [
        id,
        word,
        ipa,
        definitionVi,
        exampleSentence,
        videoSourceId,
        videoSourceTitle,
        cefrLevel,
        savedAt,
        needsReview,
      ];
}

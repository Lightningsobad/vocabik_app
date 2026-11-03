import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';

class ExerciseModel {
  final String status;
  final String videoId;
  final String cefrLevel;
  final String versionId;
  final String strategy;
  final bool isCanonical;
  final List<ExerciseBlankPositionModel> blankPositions;
  final List<ExerciseBlankModel> blanks;
  final Map<String, List<String>> answerOptions;
  final String createdAt;
  final List<ExerciseLineModel> lines;

  ExerciseModel({
    required this.status,
    required this.videoId,
    required this.cefrLevel,
    required this.versionId,
    required this.strategy,
    required this.isCanonical,
    required this.blankPositions,
    required this.blanks,
    required this.answerOptions,
    required this.createdAt,
    required this.lines,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      status: json['status'] as String? ?? '',
      videoId: json['video_id'] as String? ?? '',
      cefrLevel: json['cefr_level'] as String? ?? '',
      versionId: json['version_id'] as String? ?? '',
      strategy: json['strategy'] as String? ?? '',
      isCanonical: json['is_canonical'] as bool? ?? false,
      blankPositions: (json['blank_positions'] as List<dynamic>?)
              ?.map((e) => ExerciseBlankPositionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      blanks: (json['blanks'] as List<dynamic>?)
              ?.map((e) => ExerciseBlankModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      answerOptions: (json['answer_options'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          {},
      createdAt: json['created_at'] as String? ?? '',
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => ExerciseLineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'video_id': videoId,
      'cefr_level': cefrLevel,
      'version_id': versionId,
      'strategy': strategy,
      'is_canonical': isCanonical,
      'blank_positions': blankPositions.map((e) => e.toJson()).toList(),
      'blanks': blanks.map((e) => e.toJson()).toList(),
      'answer_options': answerOptions,
      'created_at': createdAt,
      'lines': lines.map((e) => e.toJson()).toList(),
    };
  }

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      status: status,
      videoId: videoId,
      cefrLevel: cefrLevel,
      versionId: versionId,
      strategy: strategy,
      isCanonical: isCanonical,
      blankPositions: blankPositions.map((e) => e.toEntity()).toList(),
      blanks: blanks.map((e) => e.toEntity()).toList(),
      answerOptions: answerOptions,
      createdAt: createdAt,
      lines: lines.map((e) => e.toEntity()).toList(),
    );
  }
}

class ExerciseBlankPositionModel {
  final int startMs;
  final int endMs;
  final int blankIndex;

  ExerciseBlankPositionModel({
    required this.startMs,
    required this.endMs,
    required this.blankIndex,
  });

  factory ExerciseBlankPositionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseBlankPositionModel(
      startMs: (json['start_ms'] as int?) ?? (json['startMs'] as int?) ?? 0,
      endMs: (json['end_ms'] as int?) ?? (json['endMs'] as int?) ?? 0,
      blankIndex: (json['blank_index'] as int?) ?? (json['blankIndex'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_ms': startMs,
      'end_ms': endMs,
      'blank_index': blankIndex,
    };
  }

  ExerciseBlankPositionEntity toEntity() {
    return ExerciseBlankPositionEntity(
      startMs: startMs,
      endMs: endMs,
      blankIndex: blankIndex,
    );
  }
}

class ExerciseBlankModel {
  final int blankIndex;
  final String correctAnswer;

  ExerciseBlankModel({
    required this.blankIndex,
    required this.correctAnswer,
  });

  factory ExerciseBlankModel.fromJson(Map<String, dynamic> json) {
    return ExerciseBlankModel(
      blankIndex: (json['blank_index'] as int?) ?? (json['blankIndex'] as int?) ?? 0,
      correctAnswer: (json['correct_answer'] as String?) ?? (json['correctAnswer'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blank_index': blankIndex,
      'correct_answer': correctAnswer,
    };
  }

  ExerciseBlankEntity toEntity() {
    return ExerciseBlankEntity(
      blankIndex: blankIndex,
      correctAnswer: correctAnswer,
    );
  }
}

class ExerciseLineModel {
  final int lineIndex;
  final int startMs;
  final int endMs;
  final int sentenceIndex;
  final List<ExerciseTokenModel> tokens;

  ExerciseLineModel({
    required this.lineIndex,
    required this.startMs,
    required this.endMs,
    required this.sentenceIndex,
    required this.tokens,
  });

  factory ExerciseLineModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLineModel(
      lineIndex: (json['line_index'] as int?) ?? (json['lineIndex'] as int?) ?? 0,
      startMs: (json['start_ms'] as int?) ?? (json['startMs'] as int?) ?? 0,
      endMs: (json['end_ms'] as int?) ?? (json['endMs'] as int?) ?? 0,
      sentenceIndex: (json['sentence_index'] as int?) ?? (json['sentenceIndex'] as int?) ?? 0,
      tokens: (json['tokens'] as List<dynamic>?)
              ?.map((e) => ExerciseTokenModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line_index': lineIndex,
      'start_ms': startMs,
      'end_ms': endMs,
      'sentence_index': sentenceIndex,
      'tokens': tokens.map((e) => e.toJson()).toList(),
    };
  }

  ExerciseLineEntity toEntity() {
    return ExerciseLineEntity(
      lineIndex: lineIndex,
      startMs: startMs,
      endMs: endMs,
      sentenceIndex: sentenceIndex,
      tokens: tokens.map((e) => e.toEntity()).toList(),
    );
  }
}

class ExerciseTokenModel {
  final String? text;
  final bool isBlank;
  final int? blankIndex;

  ExerciseTokenModel({
    this.text,
    required this.isBlank,
    this.blankIndex,
  });

  factory ExerciseTokenModel.fromJson(Map<String, dynamic> json) {
    return ExerciseTokenModel(
      text: json['text'] as String?,
      isBlank: (json['is_blank'] as bool?) ?? (json['isBlank'] as bool?) ?? false,
      blankIndex: (json['blank_index'] as int?) ?? (json['blankIndex'] as int?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text,
      'is_blank': isBlank,
      if (blankIndex != null) 'blank_index': blankIndex,
    };
  }

  ExerciseTokenEntity toEntity() {
    return ExerciseTokenEntity(
      text: text,
      isBlank: isBlank,
      blankIndex: blankIndex,
    );
  }
}

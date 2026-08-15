import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String status;
  final String videoId;
  final String cefrLevel;
  final String versionId;
  final String strategy;
  final bool isCanonical;
  final List<ExerciseBlankPositionEntity> blankPositions;
  final List<ExerciseBlankEntity> blanks;
  final Map<String, List<String>> answerOptions;
  final String createdAt;
  final List<ExerciseLineEntity> lines;

  const ExerciseEntity({
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

  @override
  List<Object?> get props => [
        status,
        videoId,
        cefrLevel,
        versionId,
        strategy,
        isCanonical,
        blankPositions,
        blanks,
        answerOptions,
        createdAt,
        lines,
      ];
}

class ExerciseBlankPositionEntity extends Equatable {
  final int startMs;
  final int endMs;
  final int blankIndex;

  const ExerciseBlankPositionEntity({
    required this.startMs,
    required this.endMs,
    required this.blankIndex,
  });

  @override
  List<Object?> get props => [startMs, endMs, blankIndex];
}

class ExerciseBlankEntity extends Equatable {
  final int blankIndex;
  final String correctAnswer;

  const ExerciseBlankEntity({
    required this.blankIndex,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [blankIndex, correctAnswer];
}

class ExerciseLineEntity extends Equatable {
  final int lineIndex;
  final int startMs;
  final int endMs;
  final int sentenceIndex;
  final List<ExerciseTokenEntity> tokens;

  const ExerciseLineEntity({
    required this.lineIndex,
    required this.startMs,
    required this.endMs,
    required this.sentenceIndex,
    required this.tokens,
  });

  @override
  List<Object?> get props => [lineIndex, startMs, endMs, sentenceIndex, tokens];
}

class ExerciseTokenEntity extends Equatable {
  final String? text;
  final bool isBlank;
  final int? blankIndex;

  const ExerciseTokenEntity({
    this.text,
    required this.isBlank,
    this.blankIndex,
  });

  @override
  List<Object?> get props => [text, isBlank, blankIndex];
}

import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  static const _defaultLine = ExerciseLineEntity(
    lineIndex: 0,
    startMs: 0,
    endMs: 0,
    sentenceIndex: 0,
    tokens: [],
  );

  final ExerciseEntity exercise;
  final int currentBlankIndex;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> checkResults; // true if correct, false if incorrect
  final bool isFinished;
  final bool hintUsedForCurrentBlank;
  final Map<int, String> translations;
  final bool isTranslationVisible;
  final Map<int, int> blankEndMsMap;
  final List<int> stopPointMs;
  final Map<int, ExerciseLineEntity> activeLineMap;

  ExerciseLoaded({
    required this.exercise,
    this.currentBlankIndex = 0,
    this.selectedAnswers = const {},
    this.checkResults = const {},
    this.isFinished = false,
    this.hintUsedForCurrentBlank = false,
    this.translations = const {},
    this.isTranslationVisible = false,
    Map<int, int>? blankEndMsMap,
    List<int>? stopPointMs,
    Map<int, ExerciseLineEntity>? activeLineMap,
  })  : blankEndMsMap = blankEndMsMap ?? _computeBlankEndMsMap(exercise),
        stopPointMs = stopPointMs ?? _computeStopPointMs(exercise),
        activeLineMap = activeLineMap ?? _computeActiveLineMap(exercise);

  static ExerciseLineEntity _findLineForBlank(
    ExerciseEntity exercise,
    int blankIndex,
  ) {
    // 1. Match by token's blankIndex in lines
    for (final line in exercise.lines) {
      if (line.tokens.any((t) => t.blankIndex == blankIndex)) {
        return line;
      }
    }

    // 2. Match by blankPositions if available
    final blankPos = exercise.blankPositions
        .where((p) => p.blankIndex == blankIndex)
        .firstOrNull;

    if (blankPos != null && exercise.lines.isNotEmpty) {
      // Find line overlapping with blank position
      final overlappingLine = exercise.lines.where((l) {
        return (l.startMs <= blankPos.startMs && l.endMs >= blankPos.endMs) ||
            (l.startMs <= blankPos.endMs && l.endMs >= blankPos.startMs);
      }).firstOrNull;

      if (overlappingLine != null) {
        return overlappingLine;
      }

      // Find closest line starting before or at blank position
      final precedingLine = exercise.lines
          .where((l) => l.startMs <= blankPos.startMs)
          .lastOrNull;
      if (precedingLine != null) {
        return precedingLine;
      }
    } else if (blankPos != null && exercise.lines.isEmpty) {
      return ExerciseLineEntity(
        lineIndex: blankIndex,
        startMs: blankPos.startMs,
        endMs: blankPos.endMs,
        sentenceIndex: 0,
        tokens: [
          ExerciseTokenEntity(isBlank: true, blankIndex: blankIndex),
        ],
      );
    }

    // 3. Match by index in blanks list if blanks and lines have 1:1 correspondence
    final blankIdxInList =
        exercise.blanks.indexWhere((b) => b.blankIndex == blankIndex);
    if (blankIdxInList >= 0 && blankIdxInList < exercise.lines.length) {
      return exercise.lines[blankIdxInList];
    }

    // 4. Default fallback
    return exercise.lines.isNotEmpty ? exercise.lines.first : _defaultLine;
  }

  static Map<int, int> _computeBlankEndMsMap(ExerciseEntity exercise) {
    final map = <int, int>{};
    for (final blank in exercise.blanks) {
      final line = _findLineForBlank(exercise, blank.blankIndex);
      if (line.endMs > 0) {
        map[blank.blankIndex] = line.endMs;
      } else {
        final blankPos = exercise.blankPositions
            .where((p) => p.blankIndex == blank.blankIndex)
            .firstOrNull;
        map[blank.blankIndex] = blankPos?.endMs ?? line.endMs;
      }
    }
    return map;
  }

  static List<int> _computeStopPointMs(ExerciseEntity exercise) {
    final endMsMap = _computeBlankEndMsMap(exercise);
    return exercise.blanks.map((b) => endMsMap[b.blankIndex] ?? 0).toList();
  }

  static Map<int, ExerciseLineEntity> _computeActiveLineMap(
    ExerciseEntity exercise,
  ) {
    final map = <int, ExerciseLineEntity>{};
    for (final blank in exercise.blanks) {
      map[blank.blankIndex] = _findLineForBlank(exercise, blank.blankIndex);
    }
    return map;
  }

  ExerciseLoaded copyWith({
    ExerciseEntity? exercise,
    int? currentBlankIndex,
    Map<int, String>? selectedAnswers,
    Map<int, bool>? checkResults,
    bool? isFinished,
    bool? hintUsedForCurrentBlank,
    Map<int, String>? translations,
    bool? isTranslationVisible,
  }) {
    return ExerciseLoaded(
      exercise: exercise ?? this.exercise,
      currentBlankIndex: currentBlankIndex ?? this.currentBlankIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      checkResults: checkResults ?? this.checkResults,
      isFinished: isFinished ?? this.isFinished,
      hintUsedForCurrentBlank:
          hintUsedForCurrentBlank ?? this.hintUsedForCurrentBlank,
      translations: translations ?? this.translations,
      isTranslationVisible: isTranslationVisible ?? this.isTranslationVisible,
      blankEndMsMap: exercise != null ? null : blankEndMsMap,
      stopPointMs: exercise != null ? null : stopPointMs,
      activeLineMap: exercise != null ? null : activeLineMap,
    );
  }

  int get totalSteps => exercise.blanks.length;

  int get currentStepIndex =>
      exercise.blanks.indexWhere((b) => b.blankIndex == currentBlankIndex);

  int get currentStep =>
      currentStepIndex >= 0 ? currentStepIndex + 1 : (totalSteps > 0 ? 1 : 0);

  double get progress => totalSteps > 0 ? currentStep / totalSteps : 0.0;

  ExerciseLineEntity get activeLine =>
      activeLineMap[currentBlankIndex] ??
      (exercise.lines.isNotEmpty ? exercise.lines.first : _defaultLine);

  @override
  List<Object?> get props => [
        exercise,
        currentBlankIndex,
        selectedAnswers,
        checkResults,
        isFinished,
        hintUsedForCurrentBlank,
        translations,
        isTranslationVisible,
        blankEndMsMap,
        stopPointMs,
        activeLineMap,
      ];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}

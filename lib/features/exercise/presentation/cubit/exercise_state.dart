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
  final ExerciseEntity exercise;
  final int currentBlankIndex;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> checkResults; // true if correct, false if incorrect
  final bool isFinished;
  final bool hintUsedForCurrentBlank;
  final Map<int, int> blankEndMsMap;
  final List<int> stopPointMs;

  ExerciseLoaded({
    required this.exercise,
    this.currentBlankIndex = 0,
    this.selectedAnswers = const {},
    this.checkResults = const {},
    this.isFinished = false,
    this.hintUsedForCurrentBlank = false,
    Map<int, int>? blankEndMsMap,
    List<int>? stopPointMs,
  })  : blankEndMsMap = blankEndMsMap ?? _computeBlankEndMsMap(exercise),
        stopPointMs = stopPointMs ?? _computeStopPointMs(exercise);

  static Map<int, int> _computeBlankEndMsMap(ExerciseEntity exercise) {
    final map = <int, int>{};
    for (final blank in exercise.blanks) {
      final line = exercise.lines.firstWhere(
        (l) => l.tokens.any((t) => t.blankIndex == blank.blankIndex),
        orElse: () => exercise.lines.isNotEmpty
            ? exercise.lines.first
            : const ExerciseLineEntity(
                lineIndex: 0,
                startMs: 0,
                endMs: 0,
                sentenceIndex: 0,
                tokens: [],
              ),
      );
      map[blank.blankIndex] = line.endMs;
    }
    return map;
  }

  static List<int> _computeStopPointMs(ExerciseEntity exercise) {
    final list = <int>[];
    for (final blank in exercise.blanks) {
      final line = exercise.lines.firstWhere(
        (l) => l.tokens.any((t) => t.blankIndex == blank.blankIndex),
        orElse: () => exercise.lines.isNotEmpty
            ? exercise.lines.first
            : const ExerciseLineEntity(
                lineIndex: 0,
                startMs: 0,
                endMs: 0,
                sentenceIndex: 0,
                tokens: [],
              ),
      );
      list.add(line.endMs);
    }
    return list;
  }

  ExerciseLoaded copyWith({
    ExerciseEntity? exercise,
    int? currentBlankIndex,
    Map<int, String>? selectedAnswers,
    Map<int, bool>? checkResults,
    bool? isFinished,
    bool? hintUsedForCurrentBlank,
  }) {
    return ExerciseLoaded(
      exercise: exercise ?? this.exercise,
      currentBlankIndex: currentBlankIndex ?? this.currentBlankIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      checkResults: checkResults ?? this.checkResults,
      isFinished: isFinished ?? this.isFinished,
      hintUsedForCurrentBlank:
          hintUsedForCurrentBlank ?? this.hintUsedForCurrentBlank,
      blankEndMsMap: exercise != null ? null : blankEndMsMap,
      stopPointMs: exercise != null ? null : stopPointMs,
    );
  }

  int get totalSteps => exercise.blanks.length;

  int get currentStepIndex =>
      exercise.blanks.indexWhere((b) => b.blankIndex == currentBlankIndex);

  int get currentStep =>
      currentStepIndex >= 0 ? currentStepIndex + 1 : (totalSteps > 0 ? 1 : 0);

  double get progress => totalSteps > 0 ? currentStep / totalSteps : 0.0;

  ExerciseLineEntity get activeLine => exercise.lines.firstWhere(
        (line) => line.tokens.any((t) => t.blankIndex == currentBlankIndex),
        orElse: () => exercise.lines.isNotEmpty
            ? exercise.lines.first
            : const ExerciseLineEntity(
                lineIndex: 0,
                startMs: 0,
                endMs: 0,
                sentenceIndex: 0,
                tokens: [],
              ),
      );

  @override
  List<Object?> get props => [
        exercise,
        currentBlankIndex,
        selectedAnswers,
        checkResults,
        isFinished,
        hintUsedForCurrentBlank,
        blankEndMsMap,
        stopPointMs,
      ];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}

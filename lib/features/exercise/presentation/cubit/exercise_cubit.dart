import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/usecases/get_exercise_usecase.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';

@injectable
class ExerciseCubit extends Cubit<ExerciseState> {
  final GetExerciseUseCase getExerciseUseCase;
  CancelToken? _cancelToken;

  ExerciseCubit(this.getExerciseUseCase) : super(ExerciseInitial());

  Future<void> loadExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
  }) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    emit(ExerciseLoading());
    final result = await getExerciseUseCase(
      GetExerciseParams(
        videoId: videoId,
        cefrLevel: cefrLevel,
        versionId: versionId,
        cancelToken: _cancelToken,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure.message == 'Request cancelled') return;
        emit(ExerciseError(failure.message));
      },
      (exercise) {
        final initialBlankIndex =
            exercise.blanks.isNotEmpty ? exercise.blanks.first.blankIndex : 0;
        emit(ExerciseLoaded(
          exercise: exercise,
          currentBlankIndex: initialBlankIndex,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }

  void selectAnswer(String answer) {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      
      // If already answered/checked for current blank, don't allow changing
      if (currentState.checkResults.containsKey(currentState.currentBlankIndex)) {
        return;
      }

      final newSelectedAnswers = Map<int, String>.from(currentState.selectedAnswers);
      newSelectedAnswers[currentState.currentBlankIndex] = answer;

      // Find correct answer & check immediately
      final currentBlankIndex = currentState.currentBlankIndex;
      final blankData = currentState.exercise.blanks.firstWhere(
        (b) => b.blankIndex == currentBlankIndex,
        orElse: () => ExerciseBlankEntity(blankIndex: currentBlankIndex, correctAnswer: ''),
      );
      
      final isCorrect = blankData.correctAnswer.isNotEmpty &&
          answer.toLowerCase().trim() == blankData.correctAnswer.toLowerCase().trim();

      final newCheckResults = Map<int, bool>.from(currentState.checkResults);
      newCheckResults[currentBlankIndex] = isCorrect;

      emit(currentState.copyWith(
        selectedAnswers: newSelectedAnswers,
        checkResults: newCheckResults,
      ));
    }
  }

  void checkAnswer() {
    // Kept for backward compatibility if needed, but selectAnswer already checks immediately
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      final currentBlankIndex = currentState.currentBlankIndex;
      final selectedAnswer = currentState.selectedAnswers[currentBlankIndex];
      if (selectedAnswer != null && !currentState.checkResults.containsKey(currentBlankIndex)) {
        selectAnswer(selectedAnswer);
      }
    }
  }

  void useHint() {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      emit(currentState.copyWith(hintUsedForCurrentBlank: true));
    }
  }

  void nextBlank() {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      final currentIndexInList = currentState.exercise.blanks.indexWhere(
        (b) => b.blankIndex == currentState.currentBlankIndex,
      );

      final nextIndexInList = currentIndexInList != -1 ? currentIndexInList + 1 : 0;

      if (nextIndexInList < currentState.exercise.blanks.length) {
        final nextBlankIndex = currentState.exercise.blanks[nextIndexInList].blankIndex;
        emit(currentState.copyWith(
          currentBlankIndex: nextBlankIndex,
          hintUsedForCurrentBlank: false,
        ));
      } else {
        emit(currentState.copyWith(isFinished: true));
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/core/network/dio_cancel_token.dart';
import 'package:vocabik_app/core/utils/string_extensions.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/entities/translation_entity.dart';
import 'package:vocabik_app/features/exercise/domain/usecases/get_exercise_usecase.dart';
import 'package:vocabik_app/features/exercise/domain/usecases/get_video_translations_usecase.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';

@injectable
class ExerciseCubit extends Cubit<ExerciseState> {
  final GetExerciseUseCase getExerciseUseCase;
  final GetVideoTranslationsUseCase getVideoTranslationsUseCase;
  AppCancelToken? _cancelToken;

  ExerciseCubit(
    this.getExerciseUseCase,
    this.getVideoTranslationsUseCase,
  ) : super(ExerciseInitial());

  Future<void> loadExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
  }) async {
    _cancelToken?.cancel();
    _cancelToken = DioCancelToken();

    emit(ExerciseLoading());

    final results = await Future.wait([
      getExerciseUseCase(
        GetExerciseParams(
          videoId: videoId,
          cefrLevel: cefrLevel,
          versionId: versionId,
          cancelToken: _cancelToken,
        ),
      ),
      getVideoTranslationsUseCase(
        GetVideoTranslationsParams(
          videoId: videoId,
          cancelToken: _cancelToken,
        ),
      ),
    ]);

    if (isClosed) return;

    final exerciseResult = results[0] as dynamic;
    final translationResult = results[1] as dynamic;

    exerciseResult.fold(
      (failure) {
        if (failure is CancelledFailure) return;
        emit(ExerciseError(failure.message));
      },
      (exercise) {
        final initialBlankIndex =
            exercise.blanks.isNotEmpty ? exercise.blanks.first.blankIndex : 0;

        final Map<int, String> translationsMap = {};
        translationResult.fold(
          (failure) {
            // Ignore translation failure to allow exercise to be played
          },
          (List<TranslationEntity> translations) {
            for (final t in translations) {
              translationsMap[t.lineIndex] = t.text;
            }
          },
        );

        emit(ExerciseLoaded(
          exercise: exercise,
          currentBlankIndex: initialBlankIndex,
          translations: translationsMap,
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
      
      final cleanedUserAnswer = answer.normalizeAnswer();
      final cleanedCorrectAnswer = blankData.correctAnswer.normalizeAnswer();
      final isCorrect = cleanedCorrectAnswer.isNotEmpty &&
          cleanedUserAnswer == cleanedCorrectAnswer;

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

  void toggleTranslation() {
    if (state is ExerciseLoaded) {
      final currentState = state as ExerciseLoaded;
      emit(currentState.copyWith(
        isTranslationVisible: !currentState.isTranslationVisible,
      ));
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
          isTranslationVisible: false,
        ));
      } else {
        emit(currentState.copyWith(isFinished: true));
      }
    }
  }
}


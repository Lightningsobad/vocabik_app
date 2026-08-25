import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/core/network/dio_cancel_token.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/score_card_repository.dart';
import 'package:vocabik_app/features/exercise/domain/usecases/submit_progress_usecase.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_calculation_helper.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';

@injectable
class ResultCubit extends Cubit<ResultState> {
  final ScoreCardRepository scoreCardRepository;
  final SubmitProgressUseCase submitProgressUseCase;
  AppCancelToken? _scoreCardCancelToken;
  AppCancelToken? _progressCancelToken;

  ResultCubit(
    this.scoreCardRepository,
    this.submitProgressUseCase,
  ) : super(const ResultState());

  Future<void> initialize({
    required ExerciseEntity exercise,
    required Map<int, String> selectedAnswers,
    required Map<int, bool> checkResults,
    required int durationMs,
  }) async {
    emit(state.copyWith(isCalculating: true));

    // Calculate score & statistics using isolate compute
    final summary = await calculateExerciseResultSummary(
      ResultCalculationParams(
        exercise: exercise,
        selectedAnswers: selectedAnswers,
        checkResults: checkResults,
        durationMs: durationMs,
      ),
    );

    if (isClosed) return;

    emit(state.copyWith(
      isCalculating: false,
      summary: summary,
    ));

    // Trigger score card creation and progress submission in parallel
    generateScoreCard(
      videoId: exercise.videoId,
      cefrLevel: exercise.cefrLevel,
      accuracyScore: summary.accuracyScore,
    );

    submitProgress(
      exercise: exercise,
      summary: summary,
    );
  }

  Future<void> submitProgress({
    required ExerciseEntity exercise,
    required ExerciseResultSummary summary,
  }) async {
    _progressCancelToken?.cancel();
    _progressCancelToken = DioCancelToken();

    emit(state.copyWith(progressStatus: ProgressSubmitStatus.loading));

    final result = await submitProgressUseCase(
      SubmitProgressParams(
        videoId: exercise.videoId,
        cefrLevel: exercise.cefrLevel,
        versionId: exercise.versionId,
        completedAt: DateTime.now().toUtc().toIso8601String(),
        accuracyScore: summary.accuracyScore,
        timeTakenSeconds: summary.duration.inSeconds,
        correctAnswers: summary.correctUserAnswers,
        blankAnswers: summary.blankAnswers,
        cancelToken: _progressCancelToken,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is CancelledFailure) return;
        emit(state.copyWith(
          progressStatus: ProgressSubmitStatus.error,
          progressErrorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          progressStatus: ProgressSubmitStatus.success,
        ));
      },
    );
  }

  Future<void> generateScoreCard({
    required String videoId,
    required String cefrLevel,
    required int accuracyScore,
  }) async {
    _scoreCardCancelToken?.cancel();
    _scoreCardCancelToken = DioCancelToken();

    emit(state.copyWith(scoreCardStatus: ScoreCardStatus.loading));

    final result = await scoreCardRepository.createScoreCard(
      videoId: videoId,
      cefrLevel: cefrLevel,
      accuracyScore: accuracyScore,
      cancelToken: _scoreCardCancelToken,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is CancelledFailure) return;
        final msg = failure.message.toLowerCase();
        if (msg.contains('socket') ||
            msg.contains('network') ||
            msg.contains('connection')) {
          emit(state.copyWith(
            scoreCardStatus: ScoreCardStatus.offline,
            errorMessage: failure.message,
          ));
        } else {
          emit(state.copyWith(
            scoreCardStatus: ScoreCardStatus.error,
            errorMessage: failure.message,
          ));
        }
      },
      (scoreCardId) {
        final imageUrl = scoreCardRepository.getScoreCardImageUrl(scoreCardId);
        emit(state.copyWith(
          scoreCardStatus: ScoreCardStatus.success,
          scoreCardImageUrl: imageUrl,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _scoreCardCancelToken?.cancel();
    _progressCancelToken?.cancel();
    return super.close();
  }
}


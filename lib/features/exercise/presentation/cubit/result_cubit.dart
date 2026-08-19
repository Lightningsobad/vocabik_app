import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/exercise/data/models/score_card_request.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/score_card_repository.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_calculation_helper.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';

@injectable
class ResultCubit extends Cubit<ResultState> {
  final ScoreCardRepository scoreCardRepository;
  CancelToken? _cancelToken;

  ResultCubit(this.scoreCardRepository) : super(const ResultState());

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

    // Trigger score card creation
    await generateScoreCard(
      videoId: exercise.videoId,
      cefrLevel: exercise.cefrLevel,
      accuracyScore: summary.accuracyScore,
    );
  }

  Future<void> generateScoreCard({
    required String videoId,
    required String cefrLevel,
    required int accuracyScore,
  }) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    emit(state.copyWith(scoreCardStatus: ScoreCardStatus.loading));

    final result = await scoreCardRepository.createScoreCard(
      request: ScoreCardRequest(
        videoId: videoId,
        cefrLevel: cefrLevel,
        accuracyScore: accuracyScore,
      ),
      cancelToken: _cancelToken,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
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
    _cancelToken?.cancel();
    return super.close();
  }
}

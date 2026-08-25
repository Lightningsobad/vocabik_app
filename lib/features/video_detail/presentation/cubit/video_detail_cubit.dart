import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/utils/string_extensions.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_latest_video_progress_use_case.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_video_detail_use_case.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_video_exercise_blanks_use_case.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/send_video_reaction_use_case.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';

import 'video_detail_state.dart';

@injectable
class VideoDetailCubit extends Cubit<VideoDetailState> {
  final GetVideoDetailUseCase _getVideoDetailUseCase;
  final GetVideoExerciseBlanksUseCase _getVideoExerciseBlanksUseCase;
  final GetLatestVideoProgressUseCase _getLatestVideoProgressUseCase;
  final SendVideoReactionUseCase _sendVideoReactionUseCase;

  VideoDetailCubit(
    this._getVideoDetailUseCase,
    this._getVideoExerciseBlanksUseCase,
    this._getLatestVideoProgressUseCase,
    this._sendVideoReactionUseCase,
  ) : super(VideoDetailInitial());

  Future<void> loadVideoDetail(String id) async {
    emit(VideoDetailLoading());

    try {
      final detailFuture = _getVideoDetailUseCase(id);
      final blanksFuture = _getVideoExerciseBlanksUseCase(id);
      final progressFuture = _getLatestVideoProgressUseCase(id);

      final results = await Future.wait([detailFuture, blanksFuture, progressFuture]);
      final detailResult = results[0] as Either<Failure, VideoEntity>;
      final blanksResult = results[1] as Either<Failure, int>;
      final progressResult = results[2] as Either<Failure, VideoProgressEntity?>;

      detailResult.fold(
        (failure) => emit(VideoDetailError(message: failure.message)),
        (video) {
          final blanksCount = blanksResult.fold((_) => 0, (count) => count);
          final latestProgress = progressResult.fold((_) => null, (p) => p);

          emit(VideoDetailLoaded(
            video: video,
            selectedExerciseType: ExerciseType.multipleChoice,
            selectedVersion: video.canonicalVersion ?? 'v1',
            blanksCount: blanksCount,
            latestProgress: latestProgress,
          ));
        },
      );
    } catch (e) {
      emit(VideoDetailError(message: e.toString()));
    }
  }

  void changeExerciseType(ExerciseType exerciseType) {
    if (state is VideoDetailLoaded) {
      final currentState = state as VideoDetailLoaded;
      emit(currentState.copyWith(selectedExerciseType: exerciseType));
    }
  }

  void changeVersion(String version) {
    if (state is VideoDetailLoaded) {
      final currentState = state as VideoDetailLoaded;
      final selectedVer = version.extractVersionNumber();

      if (selectedVer <= currentState.video.maxVersionNumber) {
        emit(currentState.copyWith(selectedVersion: version));
      }
    }
  }

  Future<void> sendReaction(String reactionType) async {
    if (state is! VideoDetailLoaded) return;
    final currentState = state as VideoDetailLoaded;
    final videoId = currentState.video.id;

    final result = await _sendVideoReactionUseCase(videoId, reactionType);
    result.fold(
      (failure) {
        // Silently ignore or retain current state without breaking user experience
      },
      (reactionResult) {
        if (state is VideoDetailLoaded) {
          final latestState = state as VideoDetailLoaded;
          final updatedReactions = Set<String>.from(latestState.userReactions);
          if (reactionResult.created) {
            updatedReactions.add(reactionType);
          } else {
            updatedReactions.remove(reactionType);
          }

          final updatedVideo = latestState.video.copyWith(
            reactionCounts: reactionResult.counts,
          );
          emit(latestState.copyWith(
            video: updatedVideo,
            userReactions: updatedReactions,
          ));
        }
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_latest_video_progress_use_case.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_video_detail_use_case.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_video_exercise_blanks_use_case.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';

import 'video_detail_state.dart';

@injectable
class VideoDetailCubit extends Cubit<VideoDetailState> {
  final GetVideoDetailUseCase _getVideoDetailUseCase;
  final GetVideoExerciseBlanksUseCase _getVideoExerciseBlanksUseCase;
  final GetLatestVideoProgressUseCase _getLatestVideoProgressUseCase;

  VideoDetailCubit(
    this._getVideoDetailUseCase,
    this._getVideoExerciseBlanksUseCase,
    this._getLatestVideoProgressUseCase,
  ) : super(VideoDetailInitial());

  Future<void> loadVideoDetail(String id) async {
    emit(VideoDetailLoading());

    try {
      final detailFuture = _getVideoDetailUseCase(id);
      final blanksFuture = _getVideoExerciseBlanksUseCase(id);

      final results = await Future.wait([detailFuture, blanksFuture]);
      final detailResult = results[0] as Either<Failure, VideoEntity>;
      final blanksResult = results[1] as Either<Failure, int>;

      await detailResult.fold(
        (failure) async => emit(VideoDetailError(message: failure.message)),
        (video) async {
          final blanksCount = blanksResult.fold((_) => 0, (count) => count);

          final progressResult =
              await _getLatestVideoProgressUseCase(video.title);
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
      final selectedVer =
          int.tryParse(version.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

      if (selectedVer <= currentState.video.maxVersionNumber) {
        emit(currentState.copyWith(selectedVersion: version));
      }
    }
  }
}

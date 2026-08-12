import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/video_detail/domain/use_cases/get_video_detail_use_case.dart';

import 'video_detail_state.dart';

@injectable
class VideoDetailCubit extends Cubit<VideoDetailState> {
  final GetVideoDetailUseCase _getVideoDetailUseCase;

  VideoDetailCubit(this._getVideoDetailUseCase) : super(VideoDetailInitial());

  Future<void> loadVideoDetail(String id) async {
    emit(VideoDetailLoading());

    final result = await _getVideoDetailUseCase(id);

    result.fold(
      (failure) => emit(VideoDetailError(message: failure.message)),
      (video) {
        emit(VideoDetailLoaded(
          video: video,
          selectedExerciseType: 'Multiple choice', // Default for "Fill-blank"
          selectedVersion: video.canonicalVersion ?? 'v1',
        ));
      },
    );
  }

  void changeExerciseType(String exerciseType) {
    if (state is VideoDetailLoaded) {
      final currentState = state as VideoDetailLoaded;
      emit(currentState.copyWith(selectedExerciseType: exerciseType));
    }
  }

  void changeVersion(String version) {
    if (state is VideoDetailLoaded) {
      final currentState = state as VideoDetailLoaded;
      
      // Prevent selecting a version that is locked.
      // E.g., if canonicalVersion is 'v1', then 'v2' and 'v3' are locked.
      // Here we assume canonicalVersion determines the highest unlocked version.
      // For simplicity, we can do a naive check if it's 'v1', we only allow 'v1'.
      // If canonicalVersion is 'v2', allow 'v1', 'v2'.
      final maxVersionStr = currentState.video.canonicalVersion ?? 'v1';
      final maxVersion = int.tryParse(maxVersionStr.replaceAll('v', '')) ?? 1;
      final selectedVer = int.tryParse(version.replaceAll('v', '')) ?? 1;
      
      if (selectedVer <= maxVersion) {
         emit(currentState.copyWith(selectedVersion: version));
      }
    }
  }
}

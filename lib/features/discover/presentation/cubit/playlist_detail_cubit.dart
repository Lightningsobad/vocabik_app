import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_playlist_detail_usecase.dart';
import 'playlist_detail_state.dart';

@injectable
class PlaylistDetailCubit extends Cubit<PlaylistDetailState> {
  final GetPlaylistDetailUseCase _getPlaylistDetailUseCase;

  PlaylistDetailCubit(this._getPlaylistDetailUseCase)
      : super(PlaylistDetailInitial());

  Future<void> loadPlaylistDetail(String slug) async {
    emit(PlaylistDetailLoading());
    final result = await _getPlaylistDetailUseCase(slug);
    result.fold(
      (failure) => emit(PlaylistDetailError(failure.message)),
      (playlist) => emit(PlaylistDetailLoaded(playlist)),
    );
  }
}

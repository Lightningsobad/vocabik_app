import 'package:equatable/equatable.dart';
import '../../domain/entities/playlist_entity.dart';

abstract class PlaylistDetailState extends Equatable {
  const PlaylistDetailState();

  @override
  List<Object?> get props => [];
}

class PlaylistDetailInitial extends PlaylistDetailState {}

class PlaylistDetailLoading extends PlaylistDetailState {}

class PlaylistDetailLoaded extends PlaylistDetailState {
  final PlaylistEntity playlist;

  const PlaylistDetailLoaded(this.playlist);

  @override
  List<Object?> get props => [playlist];
}

class PlaylistDetailError extends PlaylistDetailState {
  final String message;

  const PlaylistDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

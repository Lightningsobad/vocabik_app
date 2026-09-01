import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../entities/playlist_entity.dart';
import '../repositories/playlist_repository.dart';

@injectable
class GetPlaylistDetailUseCase {
  final PlaylistRepository repository;

  GetPlaylistDetailUseCase(this.repository);

  Future<Either<Failure, PlaylistEntity>> call(String slug) {
    return repository.getPlaylistDetail(slug);
  }
}

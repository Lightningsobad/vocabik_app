import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../entities/playlist_entity.dart';
import '../repositories/playlist_repository.dart';

@injectable
class GetPlaylistsUseCase {
  final PlaylistRepository repository;

  GetPlaylistsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<PlaylistEntity>>> call({
    int page = 1,
    int pageSize = 10,
  }) {
    return repository.getPlaylists(page: page, pageSize: pageSize);
  }
}

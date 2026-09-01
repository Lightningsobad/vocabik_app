import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../entities/playlist_entity.dart';

abstract class PlaylistRepository {
  Future<Either<Failure, PaginatedResult<PlaylistEntity>>> getPlaylists({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, PlaylistEntity>> getPlaylistDetail(String slug);
}

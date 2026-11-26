import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetVideosUseCase {
  final SharedVideoRepository repository;

  GetVideosUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<VideoEntity>>> call({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
    String? searchQuery,
    bool forceRefresh = false,
    AppCancelToken? cancelToken,
  }) {
    return repository.getVideos(
      page: page,
      pageSize: pageSize,
      cefr: cefr,
      genre: genre,
      window: window,
      duration: duration,
      exerciseType: exerciseType,
      searchQuery: searchQuery,
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );
  }

  PaginatedResult<VideoEntity>? getCached({
    required int pageSize,
    String? cefr,
  }) {
    return repository.getCachedVideos(pageSize: pageSize, cefr: cefr);
  }
}

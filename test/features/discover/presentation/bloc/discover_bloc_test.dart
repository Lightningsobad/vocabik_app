import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/features/discover/domain/repositories/playlist_repository.dart';
import 'package:vocabik_app/features/discover/domain/usecases/get_playlists_usecase.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_event.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

class FakeSharedVideoRepository implements SharedVideoRepository {
  @override
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
  }) async {
    return right(
      const PaginatedResult<VideoEntity>(
        items: [],
        page: 1,
        pageSize: 20,
        totalItems: 0,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
  }) async {
    return right(const []);
  }
}

class FakePlaylistRepository implements PlaylistRepository {
  final List<PlaylistEntity> mockPlaylists;
  final bool shouldFail;

  FakePlaylistRepository({
    this.mockPlaylists = const [],
    this.shouldFail = false,
  });

  @override
  Future<Either<Failure, PaginatedResult<PlaylistEntity>>> getPlaylists({
    int page = 1,
    int pageSize = 10,
  }) async {
    if (shouldFail) {
      return left(const ServerFailure('Failed to load playlists'));
    }
    return right(
      PaginatedResult<PlaylistEntity>(
        items: mockPlaylists,
        page: page,
        pageSize: pageSize,
        totalItems: mockPlaylists.length,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Either<Failure, PlaylistEntity>> getPlaylistDetail(String slug) async {
    if (shouldFail) {
      return left(const ServerFailure('Failed to load playlist detail'));
    }
    return right(
      mockPlaylists.firstWhere(
        (p) => p.slug == slug,
        orElse: () => const PlaylistEntity(slug: 'default', title: 'Default'),
      ),
    );
  }
}

void main() {
  group('DiscoverBloc Playlist Integration', () {
    late FakeSharedVideoRepository videoRepo;
    late FakePlaylistRepository playlistRepo;
    late GetVideosUseCase getVideosUseCase;
    late GetTrendingVideosUseCase getTrendingVideosUseCase;
    late GetPlaylistsUseCase getPlaylistsUseCase;

    const tPlaylist = PlaylistEntity(
      slug: 'top-pop-hits-a2-b1',
      title: 'Pop Hits A2-B1',
      description: 'Popular Pop songs',
      coverImageUrl: 'https://i.ytimg.com/vi/iPAw5GhZplc/hqdefault.jpg',
      videoCount: 6,
      totalDurationSeconds: 1473,
    );

    setUp(() {
      videoRepo = FakeSharedVideoRepository();
      playlistRepo = FakePlaylistRepository(mockPlaylists: [tPlaylist]);
      getVideosUseCase = GetVideosUseCase(videoRepo);
      getTrendingVideosUseCase = GetTrendingVideosUseCase(videoRepo);
      getPlaylistsUseCase = GetPlaylistsUseCase(playlistRepo);
    });

    test('fetches playlists successfully on DiscoverVideosFetched', () async {
      final bloc = DiscoverBloc(
        getVideosUseCase,
        getTrendingVideosUseCase,
        getPlaylistsUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.loading &&
              state.playlistStatus == DiscoverStatus.loading),
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.success &&
              state.playlistStatus == DiscoverStatus.success &&
              state.playlists.length == 1 &&
              state.playlists.first.slug == 'top-pop-hits-a2-b1'),
        ]),
      );

      bloc.add(DiscoverVideosFetched());
    });

    test('handles playlist failure gracefully without breaking video list', () async {
      final failingPlaylistRepo = FakePlaylistRepository(shouldFail: true);
      final failingGetPlaylistsUseCase = GetPlaylistsUseCase(failingPlaylistRepo);

      final bloc = DiscoverBloc(
        getVideosUseCase,
        getTrendingVideosUseCase,
        failingGetPlaylistsUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.loading &&
              state.playlistStatus == DiscoverStatus.loading),
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.success &&
              state.playlistStatus == DiscoverStatus.failure &&
              state.playlists.isEmpty),
        ]),
      );

      bloc.add(DiscoverVideosFetched());
    });
  });
}

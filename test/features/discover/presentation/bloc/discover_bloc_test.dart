import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/features/discover/domain/repositories/playlist_repository.dart';
import 'package:vocabik_app/features/discover/domain/usecases/get_playlists_usecase.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_event.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_video_categories_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

class FakeSharedVideoRepository implements SharedVideoRepository {
  PaginatedResult<VideoEntity>? mockResult;
  Failure? mockFailure;
  String? lastSearchQuery;
  AppCancelToken? lastCancelToken;
  final List<AppCancelToken?> recordedCancelTokens = [];
  Future<Either<Failure, PaginatedResult<VideoEntity>>> Function(
    int page,
    String? cefr,
  )? onGetVideos;
  Future<Either<Failure, PaginatedResult<VideoEntity>>> Function({
    required int page,
    String? cefr,
    String? searchQuery,
    AppCancelToken? cancelToken,
  })? onGetVideosDetailed;

  @override
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
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
  }) async {
    lastSearchQuery = searchQuery;
    lastCancelToken = cancelToken;
    recordedCancelTokens.add(cancelToken);
    if (onGetVideosDetailed != null) {
      return onGetVideosDetailed!(
        page: page,
        cefr: cefr,
        searchQuery: searchQuery,
        cancelToken: cancelToken,
      );
    }
    if (onGetVideos != null) {
      return onGetVideos!(page, cefr);
    }
    if (mockFailure != null) {
      return left(mockFailure!);
    }
    return right(
      mockResult ??
          PaginatedResult<VideoEntity>(
            items: const [],
            page: page,
            pageSize: pageSize,
            totalItems: 0,
            totalPages: 1,
          ),
    );
  }

  String? lastTrendingExerciseType;
  List<VideoCategoryEntity> cachedCategories = const [];
  List<VideoCategoryEntity> mockCategories = const [];
  Failure? mockCategoriesFailure;
  Future<Either<Failure, List<VideoCategoryEntity>>> Function(bool forceRefresh)?
      onGetCategories;

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    bool forceRefresh = false,
  }) async {
    lastTrendingExerciseType = exerciseType;
    return right(const []);
  }

  @override
  List<VideoCategoryEntity> getCachedCategories() => cachedCategories;

  @override
  Future<Either<Failure, List<VideoCategoryEntity>>> getCategories({
    bool forceRefresh = false,
  }) async {
    if (onGetCategories != null) {
      return onGetCategories!(forceRefresh);
    }
    if (mockCategoriesFailure != null) {
      return left(mockCategoriesFailure!);
    }
    return right(mockCategories);
  }

  @override
  PaginatedResult<VideoEntity>? getCachedVideos({
    required int pageSize,
    String? cefr,
  }) =>
      null;

  @override
  List<VideoEntity>? getCachedTrendingVideos({String? cefr}) => null;
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
    late GetVideoCategoriesUseCase getVideoCategoriesUseCase;

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
      getVideoCategoriesUseCase = GetVideoCategoriesUseCase(videoRepo);
    });

    test('fetches playlists successfully on DiscoverVideosFetched', () async {
      final bloc = DiscoverBloc(
        getVideosUseCase,
        getTrendingVideosUseCase,
        getPlaylistsUseCase,
        getVideoCategoriesUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.loading &&
              state.playlistStatus == DiscoverStatus.loading),
          emitsThrough(
            predicate<DiscoverState>((state) =>
                state.status == DiscoverStatus.success &&
                state.playlistStatus == DiscoverStatus.success &&
                state.playlists.length == 1 &&
                state.playlists.first.slug == 'top-pop-hits-a2-b1'),
          ),
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
        getVideoCategoriesUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.loading &&
              state.playlistStatus == DiscoverStatus.loading),
          emitsThrough(
            predicate<DiscoverState>((state) =>
                state.status == DiscoverStatus.success &&
                state.playlistStatus == DiscoverStatus.failure &&
                state.playlists.isEmpty),
          ),
        ]),
      );

      bloc.add(DiscoverVideosFetched());
    });

    test('passes exerciseType filter to trending videos usecase when DiscoverFilterChanged is dispatched', () async {
      final bloc = DiscoverBloc(
        getVideosUseCase,
        getTrendingVideosUseCase,
        getPlaylistsUseCase,
        getVideoCategoriesUseCase,
      );

      bloc.add(const DiscoverFilterChanged(exerciseType: 'MC'));

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((state) =>
              state.status == DiscoverStatus.success &&
              state.exerciseType == 'MC'),
        ),
      );

      expect(videoRepo.lastTrendingExerciseType, equals('MC'));
    });
  });

  group('DiscoverBloc Library Pagination & Refresh', () {
    late FakeSharedVideoRepository videoRepo;
    late FakePlaylistRepository playlistRepo;
    late DiscoverBloc bloc;

    final video1 = VideoEntity(
      id: '1',
      youtubeVideoId: 'yt1',
      title: 'Video One',
      thumbnailUrl: 'https://example.com/1.jpg',
      category: 'tech',
      cefrLevel: 'B1',
      publishedAt: DateTime(2025, 1, 1),
      breakingBadge: false,
    );

    final video2 = VideoEntity(
      id: '2',
      youtubeVideoId: 'yt2',
      title: 'Video Two',
      thumbnailUrl: 'https://example.com/2.jpg',
      category: 'tech',
      cefrLevel: 'B1',
      publishedAt: DateTime(2025, 1, 2),
      breakingBadge: false,
    );

    setUp(() {
      videoRepo = FakeSharedVideoRepository();
      playlistRepo = FakePlaylistRepository();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('load-more pagination updates currentPage, isLoadingMore, and hasReachedMax', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.displayedVideos.length == 1 &&
              !s.hasReachedMax),
        ),
      );

      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video2],
        page: 2,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      final loadMoreFuture = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((s) => s.isLoadingMore && s.loadMoreError == null),
          predicate<DiscoverState>((s) =>
              !s.isLoadingMore &&
              s.currentPage == 2 &&
              s.hasReachedMax &&
              s.displayedVideos.length == 2),
        ]),
      );

      bloc.add(DiscoverVideosFetched());
      await loadMoreFuture;
    });

    test('load-more failure preserves loaded videos, sets loadMoreError, and recovers on retry', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      videoRepo.mockFailure = const ServerFailure('Network error');
      final errorFuture = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((s) => s.isLoadingMore && s.loadMoreError == null),
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              !s.isLoadingMore &&
              s.loadMoreError == 'Network error' &&
              s.displayedVideos.length == 1),
        ]),
      );
      bloc.add(DiscoverVideosFetched());
      await errorFuture;

      videoRepo.mockFailure = null;
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video2],
        page: 2,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      final retryFuture = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((s) => s.isLoadingMore && s.loadMoreError == null),
          predicate<DiscoverState>((s) =>
              !s.isLoadingMore &&
              s.loadMoreError == null &&
              s.currentPage == 2 &&
              s.displayedVideos.length == 2),
        ]),
      );
      bloc.add(DiscoverVideosFetched());
      await retryFuture;
    });

    test('load-more deduplicates videos by id', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1, video2, video2],
        page: 2,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      final dedupFuture = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DiscoverState>((s) => s.isLoadingMore),
          predicate<DiscoverState>((s) =>
              s.displayedVideos.map((v) => v.id).toList().length == 2 &&
              s.displayedVideos.first.id == '1' &&
              s.displayedVideos.last.id == '2'),
        ]),
      );
      bloc.add(DiscoverVideosFetched());
      await dedupFuture;
    });

    test('in-flight load-more does not overwrite newer DiscoverFilterChanged state', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      final stalePage2Completer =
          Completer<Either<Failure, PaginatedResult<VideoEntity>>>();
      final b2Video = VideoEntity(
        id: 'b2-1',
        youtubeVideoId: 'yt-b2',
        title: 'B2 Video',
        thumbnailUrl: 'https://example.com/b2.jpg',
        category: 'tech',
        cefrLevel: 'B2',
        publishedAt: DateTime(2025, 1, 3),
        breakingBadge: false,
      );

      videoRepo.onGetVideos = (page, cefr) async {
        if ((cefr == null || cefr.isEmpty) && page == 2) {
          return stalePage2Completer.future;
        }
        return right(
          PaginatedResult<VideoEntity>(
            items: [b2Video],
            page: 1,
            pageSize: 20,
            totalItems: 1,
            totalPages: 1,
          ),
        );
      };

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.isLoadingMore)),
      );

      final filterFuture = expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.cefr == 'B2' &&
              s.displayedVideos.map((v) => v.id).toList().length == 1 &&
              s.displayedVideos.first.id == 'b2-1'),
        ),
      );
      bloc.add(const DiscoverFilterChanged(cefr: 'B2'));
      await filterFuture;

      stalePage2Completer.complete(
        right(
          PaginatedResult<VideoEntity>(
            items: [video2],
            page: 2,
            pageSize: 20,
            totalItems: 2,
            totalPages: 2,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.cefr, equals('B2'));
      expect(bloc.state.displayedVideos.map((v) => v.id).toList(), equals(['b2-1']));
    });

    test('DiscoverRefreshRequested when already loaded preserves data, completes completer, and survives failure', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video2],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      final completer1 = Completer<void>();
      final emittedStates = <DiscoverState>[];
      final sub = bloc.stream.listen(emittedStates.add);

      bloc.add(DiscoverRefreshRequested(completer: completer1));
      await completer1.future;

      expect(completer1.isCompleted, isTrue);
      expect(emittedStates.any((s) => s.status == DiscoverStatus.loading), isFalse);
      expect(bloc.state.displayedVideos.map((v) => v.id).toList(), equals(['2']));

      videoRepo.mockFailure = const ServerFailure('Refresh error');
      final completer2 = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: completer2));
      await completer2.future;
      await sub.cancel();

      expect(completer2.isCompleted, isTrue);
      expect(bloc.state.status, equals(DiscoverStatus.success));
      expect(bloc.state.displayedVideos.map((v) => v.id).toList(), equals(['2']));
    });

    test('concurrent DiscoverRefreshRequested completes every completer without hanging', () async {
      final firstRefreshCompleter =
          Completer<Either<Failure, PaginatedResult<VideoEntity>>>();
      var calls = 0;
      videoRepo.onGetVideos = (page, cefr) {
        calls++;
        if (calls == 1) return firstRefreshCompleter.future;
        return Future.value(
          right(
            PaginatedResult<VideoEntity>(
              items: [video2],
              page: 1,
              pageSize: 20,
              totalItems: 1,
              totalPages: 1,
            ),
          ),
        );
      };

      final c1 = Completer<void>();
      final c2 = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: c1));
      bloc.add(DiscoverRefreshRequested(completer: c2));

      firstRefreshCompleter.complete(
        right(
          PaginatedResult<VideoEntity>(
            items: [video1],
            page: 1,
            pageSize: 20,
            totalItems: 1,
            totalPages: 1,
          ),
        ),
      );

      await Future.wait([c1.future, c2.future]);
      expect(c1.isCompleted, isTrue);
      expect(c2.isCompleted, isTrue);
    });

    test('failed refresh during in-flight load-more resets isLoadingMore to false', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      final page2Completer =
          Completer<Either<Failure, PaginatedResult<VideoEntity>>>();
      videoRepo.onGetVideos = (page, cefr) {
        if (page == 2) return page2Completer.future;
        return Future.value(left(const ServerFailure('Refresh failed')));
      };

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.isLoadingMore)),
      );

      final refreshCompleter = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: refreshCompleter));
      await refreshCompleter.future;

      page2Completer.complete(
        right(
          PaginatedResult<VideoEntity>(
            items: [video2],
            page: 2,
            pageSize: 20,
            totalItems: 2,
            totalPages: 2,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.isLoadingMore, isFalse);
      expect(bloc.state.displayedVideos.map((v) => v.id).toList(), equals(['1']));
    });

    test('DiscoverSearchQueryChanged queries server-side search API, keeps playlists/trending, and paginates with query', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );
      playlistRepo = FakePlaylistRepository(
        mockPlaylists: const [
          PlaylistEntity(slug: 'p1', title: 'Playlist 1'),
        ],
      );
      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      final nasaVideo1 = VideoEntity(
        id: 'nasa-1',
        youtubeVideoId: 'yt-nasa1',
        title: 'NASA Mars Rover',
        thumbnailUrl: 'https://i.ytimg.com/vi/7Gni54puoIg/maxresdefault.jpg',
        category: 'news',
        cefrLevel: 'B2',
        publishedAt: DateTime(2025, 2, 1),
        breakingBadge: false,
      );
      final nasaVideo2 = VideoEntity(
        id: 'nasa-2',
        youtubeVideoId: 'yt-nasa2',
        title: 'NASA Moon Base',
        thumbnailUrl: 'https://i.ytimg.com/vi/Sempwv5MPMQ/maxresdefault.jpg',
        category: 'education',
        cefrLevel: 'B2',
        publishedAt: DateTime(2025, 2, 2),
        breakingBadge: false,
      );

      videoRepo.onGetVideosDetailed = ({
        required int page,
        String? cefr,
        String? searchQuery,
        AppCancelToken? cancelToken,
      }) async {
        if (searchQuery == 'nasa' && page == 1) {
          return right(
            PaginatedResult<VideoEntity>(
              items: [nasaVideo1],
              page: 1,
              pageSize: 20,
              totalItems: 2,
              totalPages: 2,
            ),
          );
        }
        if (searchQuery == 'nasa' && page == 2) {
          return right(
            PaginatedResult<VideoEntity>(
              items: [nasaVideo2],
              page: 2,
              pageSize: 20,
              totalItems: 2,
              totalPages: 2,
            ),
          );
        }
        return right(
          PaginatedResult<VideoEntity>(
            items: [video1],
            page: 1,
            pageSize: 20,
            totalItems: 1,
            totalPages: 1,
          ),
        );
      };

      bloc.add(const DiscoverSearchQueryChanged('  nasa  '));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.searchQuery == 'nasa' &&
              s.displayedVideos.length == 1 &&
              s.displayedVideos.first.id == 'nasa-1' &&
              s.playlists.length == 1),
        ),
      );

      // Load page 2 of search results
      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              !s.isLoadingMore &&
              s.currentPage == 2 &&
              s.hasReachedMax &&
              listEquals(
                s.displayedVideos.map((v) => v.id).toList(),
                ['nasa-1', 'nasa-2'],
              )),
        ),
      );

      // Clearing search returns to browse mode
      bloc.add(const DiscoverSearchQueryChanged(''));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.searchQuery.isEmpty &&
              listEquals(
                s.displayedVideos.map((v) => v.id).toList(),
                ['1'],
              )),
        ),
      );
    });

    test('slow load-more from previous filter does not starve load-more on new filter and cancels stale token', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 2,
        totalPages: 2,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      final slowFilterAPage2 =
          Completer<Either<Failure, PaginatedResult<VideoEntity>>>();
      AppCancelToken? filterAPage2Token;
      final b2Page1 = VideoEntity(
        id: 'b2-1',
        youtubeVideoId: 'yt-b2-1',
        title: 'B2 Page 1',
        thumbnailUrl: 'https://example.com/b2-1.jpg',
        category: 'tech',
        cefrLevel: 'B2',
        publishedAt: DateTime(2025, 1, 3),
        breakingBadge: false,
      );
      final b2Page2 = VideoEntity(
        id: 'b2-2',
        youtubeVideoId: 'yt-b2-2',
        title: 'B2 Page 2',
        thumbnailUrl: 'https://example.com/b2-2.jpg',
        category: 'tech',
        cefrLevel: 'B2',
        publishedAt: DateTime(2025, 1, 4),
        breakingBadge: false,
      );

      videoRepo.onGetVideosDetailed = ({
        required int page,
        String? cefr,
        String? searchQuery,
        AppCancelToken? cancelToken,
      }) async {
        if ((cefr == null || cefr.isEmpty) && page == 2) {
          filterAPage2Token = cancelToken;
          return slowFilterAPage2.future;
        }
        if (cefr == 'B2' && page == 1) {
          return right(
            PaginatedResult<VideoEntity>(
              items: [b2Page1],
              page: 1,
              pageSize: 20,
              totalItems: 2,
              totalPages: 2,
            ),
          );
        }
        return right(
          PaginatedResult<VideoEntity>(
            items: [b2Page2],
            page: 2,
            pageSize: 20,
            totalItems: 2,
            totalPages: 2,
          ),
        );
      };

      // Start slow load-more on initial filter
      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.isLoadingMore)),
      );

      // Switch to B2 filter while slow request is still pending
      bloc.add(const DiscoverFilterChanged(cefr: 'B2'));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.cefr == 'B2' &&
              s.displayedVideos.first.id == 'b2-1'),
        ),
      );
      expect(filterAPage2Token?.isCancelled, isTrue);

      // Trigger load-more on B2 while slowFilterAPage2 has NOT completed yet
      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              !s.isLoadingMore &&
              s.currentPage == 2 &&
              listEquals(
                s.displayedVideos.map((v) => v.id).toList(),
                ['b2-1', 'b2-2'],
              )),
        ),
      );

      slowFilterAPage2.complete(left(const CancelledFailure()));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.displayedVideos.map((v) => v.id).toList(), equals(['b2-1', 'b2-2']));
    });

    test('DiscoverRefreshRequested failure emits monotonic refreshErrorId while preserving videos', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      videoRepo.mockFailure = const ServerFailure('Offline');
      final c1 = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: c1));
      await c1.future;

      expect(bloc.state.refreshError, equals('Offline'));
      expect(bloc.state.refreshErrorId, equals(1));
      expect(bloc.state.displayedVideos.map((v) => v.id).toList(), equals(['1']));

      final c2 = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: c2));
      await c2.future;

      expect(bloc.state.refreshError, equals('Offline'));
      expect(bloc.state.refreshErrorId, equals(2));
    });

    test('searching while initial load is in flight populates trending and playlists when exiting search', () async {
      final initialLibraryCompleter =
          Completer<Either<Failure, PaginatedResult<VideoEntity>>>();
      videoRepo.onGetVideosDetailed = ({
        required int page,
        String? cefr,
        String? searchQuery,
        AppCancelToken? cancelToken,
      }) {
        if (searchQuery == null || searchQuery.isEmpty) {
          if (!initialLibraryCompleter.isCompleted) {
            return initialLibraryCompleter.future;
          }
          return Future.value(
            right(
              PaginatedResult<VideoEntity>(
                items: [video1],
                page: 1,
                pageSize: 20,
                totalItems: 1,
                totalPages: 1,
              ),
            ),
          );
        }
        return Future.value(
          right(
            PaginatedResult<VideoEntity>(
              items: [video2],
              page: 1,
              pageSize: 20,
              totalItems: 43,
              totalPages: 3,
            ),
          ),
        );
      };

      playlistRepo = FakePlaylistRepository(
        mockPlaylists: const [
          PlaylistEntity(slug: 'p1', title: 'Playlist 1'),
        ],
      );
      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      // Start initial load, then immediately search before initial completes
      bloc.add(DiscoverVideosFetched());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DiscoverSearchQueryChanged('nasa'));

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.searchQuery == 'nasa' &&
              s.totalItems == 43 &&
              s.displayedVideos.map((v) => v.id).toList().join(',') == '2'),
        ),
      );
      initialLibraryCompleter.complete(left(const CancelledFailure()));

      // Clearing search must fetch full browse data so trending & playlists are not stuck loading
      bloc.add(const DiscoverSearchQueryChanged(''));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.searchQuery.isEmpty &&
              s.trendingStatus == DiscoverStatus.success &&
              s.playlistStatus == DiscoverStatus.success &&
              s.playlists.length == 1 &&
              s.displayedVideos.map((v) => v.id).toList().join(',') == '1'),
        ),
      );
    });

    test('retrying failed library search preserves already-loaded trending and playlists', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );
      playlistRepo = FakePlaylistRepository(
        mockPlaylists: const [
          PlaylistEntity(slug: 'p1', title: 'Playlist 1'),
        ],
      );
      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      videoRepo.mockFailure = const ServerFailure('Search failed');
      bloc.add(const DiscoverSearchQueryChanged('nasa'));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.failure &&
              s.searchQuery == 'nasa' &&
              s.playlists.length == 1),
        ),
      );

      videoRepo.mockFailure = null;
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video2],
        page: 1,
        pageSize: 20,
        totalItems: 12,
        totalPages: 1,
      );
      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.totalItems == 12 &&
              s.playlistStatus == DiscoverStatus.success &&
              s.playlists.length == 1 &&
              s.displayedVideos.map((v) => v.id).toList().join(',') == '2'),
        ),
      );
    });

    test('filter change in search mode updates search results and refreshes browse when exiting search', () async {
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );

      bloc.add(const DiscoverSearchQueryChanged('nasa'));
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success && s.searchQuery == 'nasa')),
      );

      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video2],
        page: 1,
        pageSize: 20,
        totalItems: 13,
        totalPages: 1,
      );
      bloc.add(const DiscoverFilterChanged(cefr: 'B2'));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.cefr == 'B2' &&
              s.searchQuery == 'nasa' &&
              s.totalItems == 13),
        ),
      );

      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 50,
        totalPages: 3,
      );
      bloc.add(const DiscoverSearchQueryChanged(''));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.searchQuery.isEmpty &&
              s.cefr == 'B2' &&
              s.totalItems == 50),
        ),
      );
    });

    test('loads categories from API and preserves them even if later calls fail', () async {
      videoRepo.mockCategories = const [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          shortLabels: {'en': 'Music', 'vi': 'Âm nhạc'},
          sortOrder: 10,
        ),
        VideoCategoryEntity(
          slug: 'kids',
          label: 'Kids',
          shortLabel: 'Kids',
          shortLabels: {'en': 'Kids', 'vi': 'Thiếu nhi'},
          sortOrder: 170,
        ),
      ];
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.categories.length == 2 &&
              s.categories.last.slug == 'kids'),
        ),
      );
    });

    test('Cache-First initializes categories immediately and background refresh updates only on diff', () async {
      const cached = [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          sortOrder: 10,
        ),
      ];
      const updated = [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          sortOrder: 10,
        ),
        VideoCategoryEntity(
          slug: 'kids',
          label: 'Kids',
          shortLabel: 'Kids',
          sortOrder: 170,
        ),
      ];

      videoRepo.cachedCategories = cached;
      final bgCompleter =
          Completer<Either<Failure, List<VideoCategoryEntity>>>();
      videoRepo.onGetCategories = (_) => bgCompleter.future;
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      // Available immediately before any event or network call
      expect(bloc.state.categories, equals(cached));

      // Feed finishes without waiting for background categories refresh
      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.categories.length == 1),
        ),
      );

      // Background refresh completes with changed categories -> emits updated state
      bgCompleter.complete(right(updated));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.categories.length == 2 && s.categories.last.slug == 'kids'),
        ),
      );

      // Refresh with identical categories does not emit duplicate state
      final emitted = <DiscoverState>[];
      final sub = bloc.stream.listen(emitted.add);
      videoRepo.onGetCategories = (_) async => right(updated);
      final refreshCompleter = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: refreshCompleter));
      await refreshCompleter.future;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await sub.cancel();

      expect(emitted.where((s) => s.categories.length == 2).length, lessThanOrEqualTo(1));
    });

    test('background categories refresh failure silently preserves cached categories', () async {
      const cached = [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          sortOrder: 10,
        ),
      ];
      videoRepo.cachedCategories = cached;
      videoRepo.mockCategoriesFailure = const ServerFailure('Categories error');
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.status, equals(DiscoverStatus.success));
      expect(bloc.state.refreshError, isNull);
      expect(bloc.state.categories, equals(cached));
    });

    test('offline initial failure retry recovers empty categories when connectivity returns', () async {
      const recovered = [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          sortOrder: 10,
        ),
      ];
      videoRepo.mockFailure = const ServerFailure('Offline');
      videoRepo.mockCategoriesFailure = const ServerFailure('Offline');

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.failure && s.categories.isEmpty),
        ),
      );

      videoRepo.mockFailure = null;
      videoRepo.mockCategoriesFailure = null;
      videoRepo.mockCategories = recovered;
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>((s) =>
              s.status == DiscoverStatus.success &&
              s.categories.length == 1 &&
              s.categories.single.slug == 'music'),
        ),
      );
    });

    test('unexpected throw in background categories refresh does not crash bloc', () async {
      videoRepo.onGetCategories = (_) => Future.error(StateError('Unexpected'));
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<DiscoverState>((s) => s.status == DiscoverStatus.success)),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(bloc.state.status, equals(DiscoverStatus.success));
      expect(bloc.state.categories, isEmpty);
      expect(bloc.state.isCategoriesLoading, isFalse);
    });

    test('cold start sets isCategoriesLoading true then false on fetch completion or failure', () async {
      final bgCompleter =
          Completer<Either<Failure, List<VideoCategoryEntity>>>();
      videoRepo.onGetCategories = (_) => bgCompleter.future;
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      expect(bloc.state.categories, isEmpty);
      expect(bloc.state.isCategoriesLoading, isTrue);

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>(
            (s) => s.status == DiscoverStatus.success && s.isCategoriesLoading,
          ),
        ),
      );

      bgCompleter.complete(left(const ServerFailure('Offline')));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>(
            (s) => !s.isCategoriesLoading && s.categories.isEmpty,
          ),
        ),
      );
    });

    test('warm start with cached categories sets isCategoriesLoading false immediately', () async {
      const cached = [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          sortOrder: 10,
        ),
      ];
      videoRepo.cachedCategories = cached;

      await bloc.close();
      bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );

      expect(bloc.state.categories, equals(cached));
      expect(bloc.state.isCategoriesLoading, isFalse);
    });

    test('DiscoverRefreshRequested sets isCategoriesLoading true when categories empty and clears on completion', () async {
      const recovered = [
        VideoCategoryEntity(
          slug: 'music',
          label: 'Music',
          shortLabel: 'Music',
          sortOrder: 10,
        ),
      ];
      videoRepo.mockFailure = const ServerFailure('Offline');
      videoRepo.mockCategoriesFailure = const ServerFailure('Offline');

      bloc.add(DiscoverVideosFetched());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>(
            (s) =>
                s.status == DiscoverStatus.failure &&
                s.categories.isEmpty &&
                !s.isCategoriesLoading,
          ),
        ),
      );

      final refreshCategoriesCompleter =
          Completer<Either<Failure, List<VideoCategoryEntity>>>();
      videoRepo.mockFailure = null;
      videoRepo.mockCategoriesFailure = null;
      videoRepo.onGetCategories = (_) => refreshCategoriesCompleter.future;
      videoRepo.mockResult = PaginatedResult<VideoEntity>(
        items: [video1],
        page: 1,
        pageSize: 20,
        totalItems: 1,
        totalPages: 1,
      );

      final refreshCompleter = Completer<void>();
      bloc.add(DiscoverRefreshRequested(completer: refreshCompleter));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>(
            (s) => s.isCategoriesLoading && s.categories.isEmpty,
          ),
        ),
      );
      await refreshCompleter.future;

      refreshCategoriesCompleter.complete(right(recovered));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<DiscoverState>(
            (s) =>
                !s.isCategoriesLoading &&
                s.categories.length == 1 &&
                s.categories.single.slug == 'music',
          ),
        ),
      );
    });
  });
}

import 'dart:async';

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
  PaginatedResult<VideoEntity>? mockResult;
  Failure? mockFailure;
  Future<Either<Failure, PaginatedResult<VideoEntity>>> Function(
    int page,
    String? cefr,
  )? onGetVideos;

  @override
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
    bool forceRefresh = false,
  }) async {
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

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
  }) async {
    lastTrendingExerciseType = exerciseType;
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

    test('passes exerciseType filter to trending videos usecase when DiscoverFilterChanged is dispatched', () async {
      final bloc = DiscoverBloc(
        getVideosUseCase,
        getTrendingVideosUseCase,
        getPlaylistsUseCase,
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
  });
}

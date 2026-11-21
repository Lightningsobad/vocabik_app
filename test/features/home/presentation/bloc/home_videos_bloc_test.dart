import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

class FakeSharedVideoRepository implements SharedVideoRepository {
  PaginatedResult<VideoEntity>? mockResult;
  Failure? mockFailure;
  Future<Either<Failure, PaginatedResult<VideoEntity>>> Function(int page, String? cefr)? onGetVideos;

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
    if (onGetVideos != null) {
      return onGetVideos!(page, cefr);
    }
    if (mockFailure != null) {
      return left(mockFailure!);
    }
    return right(
      mockResult ??
          PaginatedResult<VideoEntity>(
            items: [],
            page: page,
            pageSize: pageSize,
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
    String? exerciseType,
  }) async {
    return right(const []);
  }
}

void main() {
  late FakeSharedVideoRepository repository;
  late GetVideosUseCase useCase;
  late HomeVideosBloc bloc;

  final sampleVideo = VideoEntity(
    id: '1',
    youtubeVideoId: 'yt1',
    title: 'Test Video',
    thumbnailUrl: 'http://thumb.jpg',
    category: 'tech',
    cefrLevel: 'b1',
    publishedAt: DateTime(2025, 1, 1),
    breakingBadge: false,
  );

  setUp(() {
    repository = FakeSharedVideoRepository();
    useCase = GetVideosUseCase(repository);
    bloc = HomeVideosBloc(useCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('FetchVideos emits HomeVideosLoaded with correct totalItems from API response', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 85,
      totalPages: 5,
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const HomeVideosLoading(),
        isA<HomeVideosLoaded>()
            .having((s) => s.totalItems, 'totalItems', 85)
            .having((s) => s.videos.length, 'videos.length', 1)
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.hasReachedMax, 'hasReachedMax', false),
      ]),
    );

    bloc.add(const FetchVideos());
  });

  test('FetchVideos pagination preserves/updates totalItems', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 85,
      totalPages: 2,
    );

    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<HomeVideosLoaded>().having((s) => s.totalItems, 'totalItems', 85),
      ),
    );

    final secondVideo = VideoEntity(
      id: '2',
      youtubeVideoId: 'yt2',
      title: 'Second Video',
      thumbnailUrl: 'http://thumb2.jpg',
      category: 'tech',
      cefrLevel: 'b1',
      publishedAt: DateTime(2025, 1, 2),
      breakingBadge: false,
    );

    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [secondVideo],
      page: 2,
      pageSize: 20,
      totalItems: 85,
      totalPages: 2,
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeVideosLoaded>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.videos.length, 'videos.length', 1),
        isA<HomeVideosLoaded>()
            .having((s) => s.totalItems, 'totalItems', 85)
            .having((s) => s.videos.length, 'videos.length', 2)
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ]),
    );

    bloc.add(const FetchVideos());
  });

  test('FetchVideos keeps existing videos and sets loadMoreError when page 2 fails, then recovers on retry', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 40,
      totalPages: 2,
    );

    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeVideosLoaded>()),
    );

    repository.mockFailure = const ServerFailure('Network error');

    final errorFuture = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeVideosLoaded>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.loadMoreError, 'loadMoreError', null),
        isA<HomeVideosLoaded>()
            .having((s) => s.videos.length, 'videos.length', 1)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.loadMoreError, 'loadMoreError', 'Network error'),
      ]),
    );
    bloc.add(const FetchVideos());
    await errorFuture;

    repository.mockFailure = null;
    final secondVideo = VideoEntity(
      id: '2',
      youtubeVideoId: 'yt2',
      title: 'Second Video',
      thumbnailUrl: 'http://thumb2.jpg',
      category: 'tech',
      cefrLevel: 'b1',
      publishedAt: DateTime(2025, 1, 2),
      breakingBadge: false,
    );
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [secondVideo],
      page: 2,
      pageSize: 20,
      totalItems: 40,
      totalPages: 2,
    );

    final retryFuture = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeVideosLoaded>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.loadMoreError, 'loadMoreError', null),
        isA<HomeVideosLoaded>()
            .having((s) => s.videos.length, 'videos.length', 2)
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.loadMoreError, 'loadMoreError', null),
      ]),
    );

    bloc.add(const FetchVideos());
    await retryFuture;
  });

  test('FetchVideos deduplicates videos by id when next page returns overlapping items', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 40,
      totalPages: 2,
    );

    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeVideosLoaded>()),
    );

    final secondVideo = VideoEntity(
      id: '2',
      youtubeVideoId: 'yt2',
      title: 'Second Video',
      thumbnailUrl: 'http://thumb2.jpg',
      category: 'tech',
      cefrLevel: 'b1',
      publishedAt: DateTime(2025, 1, 2),
      breakingBadge: false,
    );
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo, secondVideo, secondVideo],
      page: 2,
      pageSize: 20,
      totalItems: 40,
      totalPages: 2,
    );

    final dedupeFuture = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeVideosLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<HomeVideosLoaded>()
            .having((s) => s.videos.length, 'videos.length', 2)
            .having((s) => s.videos.map((v) => v.id).toList(), 'ids', ['1', '2']),
      ]),
    );

    bloc.add(const FetchVideos());
    await dedupeFuture;
  });

  test('RefreshVideos when already loaded does not emit HomeVideosLoading and completes completer', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 85,
      totalPages: 5,
    );

    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeVideosLoaded>()),
    );

    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 90,
      totalPages: 5,
    );

    final completer = Completer<void>();
    final refreshFuture = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeVideosLoaded>()
            .having((s) => s.totalItems, 'totalItems', 90)
            .having((s) => s.currentPage, 'currentPage', 1),
      ]),
    );

    bloc.add(RefreshVideos(completer: completer));
    await Future.wait([completer.future, refreshFuture]);
    expect(completer.isCompleted, isTrue);
  });

  test('RefreshVideos failure when already loaded preserves videos and completes completer', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 85,
      totalPages: 5,
    );

    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeVideosLoaded>()),
    );

    repository.mockFailure = const ServerFailure('Refresh failed');
    final completer = Completer<void>();
    bloc.add(RefreshVideos(completer: completer));
    await completer.future;

    expect(completer.isCompleted, isTrue);
    expect(bloc.state, isA<HomeVideosLoaded>().having((s) => s.videos.length, 'videos.length', 1));
  });

  test('in-flight FetchVideos does not overwrite newer ChangeCefrFilter state', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 40,
      totalPages: 2,
    );

    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeVideosLoaded>()),
    );

    final stalePage2Completer = Completer<Either<Failure, PaginatedResult<VideoEntity>>>();
    final b2Video = VideoEntity(
      id: 'b2-1',
      youtubeVideoId: 'yt-b2',
      title: 'B2 Video',
      thumbnailUrl: 'http://thumb-b2.jpg',
      category: 'tech',
      cefrLevel: 'b2',
      publishedAt: DateTime(2025, 1, 3),
      breakingBadge: false,
    );

    repository.onGetVideos = (page, cefr) async {
      if (cefr == null && page == 2) {
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

    // Start page 2 fetch, then switch CEFR filter before page 2 completes
    bloc.add(const FetchVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeVideosLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true)),
    );

    final filterFuture = expectLater(
      bloc.stream,
      emitsInOrder([
        const HomeVideosLoading(currentCefr: 'b2'),
        isA<HomeVideosLoaded>()
            .having((s) => s.currentCefr, 'currentCefr', 'b2')
            .having((s) => s.videos.map((v) => v.id).toList(), 'ids', ['b2-1']),
      ]),
    );
    bloc.add(const ChangeCefrFilter('b2'));
    await filterFuture;

    // Now resolve the stale page 2 response; state must remain B2
    stalePage2Completer.complete(
      right(
        PaginatedResult<VideoEntity>(
          items: [sampleVideo],
          page: 2,
          pageSize: 20,
          totalItems: 40,
          totalPages: 2,
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(
      bloc.state,
      isA<HomeVideosLoaded>()
          .having((s) => s.currentCefr, 'currentCefr', 'b2')
          .having((s) => s.videos.map((v) => v.id).toList(), 'ids', ['b2-1']),
    );
  });

  test('ChangeCefrFilter emits HomeVideosLoaded with filter-specific totalItems', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 24,
      totalPages: 2,
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const HomeVideosLoading(currentCefr: 'b2'),
        isA<HomeVideosLoaded>()
            .having((s) => s.totalItems, 'totalItems', 24)
            .having((s) => s.currentCefr, 'currentCefr', 'b2'),
      ]),
    );

    bloc.add(const ChangeCefrFilter('b2'));
  });

  test('RefreshVideos emits HomeVideosLoaded with updated totalItems', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 20,
      totalItems: 120,
      totalPages: 6,
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const HomeVideosLoading(),
        isA<HomeVideosLoaded>()
            .having((s) => s.totalItems, 'totalItems', 120)
            .having((s) => s.currentPage, 'currentPage', 1),
      ]),
    );

    bloc.add(const RefreshVideos());
  });
}

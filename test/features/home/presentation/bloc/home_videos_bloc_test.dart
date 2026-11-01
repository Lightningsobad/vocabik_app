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
            .having((s) => s.totalItems, 'totalItems', 85)
            .having((s) => s.videos.length, 'videos.length', 2)
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true),
      ]),
    );

    bloc.add(const FetchVideos());
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

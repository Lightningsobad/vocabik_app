import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

class _FakeSharedVideoRepository implements SharedVideoRepository {
  PaginatedResult<VideoEntity>? mockResult;
  Failure? mockFailure;
  bool? lastForceRefresh;

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
    lastForceRefresh = forceRefresh;
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

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
  }) async {
    return right(const []);
  }

  @override
  List<VideoCategoryEntity> getCachedCategories() => const [];

  @override
  Future<Either<Failure, List<VideoCategoryEntity>>> getCategories({
    bool forceRefresh = false,
  }) async {
    return right(const []);
  }
}

void main() {
  late _FakeSharedVideoRepository repository;
  late HomeNewlyBloc bloc;

  final sampleVideo = VideoEntity(
    id: 'newly-1',
    youtubeVideoId: 'yt-newly-1',
    title: 'Newly Video',
    thumbnailUrl: 'https://example.com/newly.jpg',
    category: 'tech',
    cefrLevel: 'b1',
    publishedAt: DateTime(2026, 1, 1),
    breakingBadge: false,
  );

  setUp(() {
    repository = _FakeSharedVideoRepository();
    bloc = HomeNewlyBloc(GetVideosUseCase(repository));
  });

  tearDown(() {
    bloc.close();
  });

  test('RefreshNewlyVideos failure preserves existing HomeNewlyLoaded videos and passes forceRefresh', () async {
    repository.mockResult = PaginatedResult<VideoEntity>(
      items: [sampleVideo],
      page: 1,
      pageSize: 10,
      totalItems: 1,
      totalPages: 1,
    );

    bloc.add(const FetchNewlyVideos());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<HomeNewlyLoaded>()),
    );

    repository.mockFailure = const ServerFailure('Offline');
    bloc.add(const RefreshNewlyVideos());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(repository.lastForceRefresh, isTrue);
    expect(
      bloc.state,
      isA<HomeNewlyLoaded>()
          .having((s) => s.videos.length, 'videos.length', 1)
          .having((s) => s.videos.first.id, 'id', 'newly-1'),
    );
  });

  test('RefreshNewlyVideos failure when not loaded emits HomeNewlyError', () async {
    repository.mockFailure = const ServerFailure('Offline');

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HomeNewlyError>().having((s) => s.message, 'message', 'Offline'),
      ]),
    );

    bloc.add(const RefreshNewlyVideos());
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_remote_data_source.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';
import 'package:vocabik_app/shared/data/repositories/shared_video_repository_impl.dart';

class _FakeSharedVideoRemoteDataSource implements SharedVideoRemoteDataSource {
  int getVideosCalls = 0;
  PaginatedVideoResponseModel? Function({
    required int page,
    required int pageSize,
    String? cefr,
  })? onGetVideos;
  Object? errorToThrow;

  @override
  Future<PaginatedVideoResponseModel> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
  }) async {
    getVideosCalls++;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    if (onGetVideos != null) {
      return onGetVideos!(page: page, pageSize: pageSize, cefr: cefr)!;
    }
    return PaginatedVideoResponseModel(
      items: List.generate(
        pageSize,
        (i) => VideoModel(
          id: '${cefr ?? 'all'}-$pageSize-$page-$i',
          youtubeVideoId: 'yt-$i',
          title: 'Video $i',
          thumbnailUrl: 'https://example.com/$i.jpg',
          category: 'tech',
          cefrLevel: cefr ?? 'b1',
          publishedAt: DateTime(2025, 1, 1),
          breakingBadge: false,
        ),
      ),
      page: page,
      pageSize: pageSize,
      totalItems: 100,
      totalPages: 5,
    );
  }

  @override
  Future<List<VideoModel>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
  }) async {
    return const [];
  }
}

void main() {
  late _FakeSharedVideoRemoteDataSource remoteDataSource;
  late DateTime currentTime;
  late SharedVideoRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _FakeSharedVideoRemoteDataSource();
    currentTime = DateTime(2026, 1, 1, 12, 0, 0);
    repository = SharedVideoRepositoryImpl.withClock(
      remoteDataSource,
      () => currentTime,
    );
  });

  test('returns cached page 1 within TTL without calling remote again', () async {
    final first = await repository.getVideos(page: 1, pageSize: 20);
    currentTime = currentTime.add(const Duration(minutes: 2));
    final second = await repository.getVideos(page: 1, pageSize: 20);

    expect(first.isRight(), isTrue);
    expect(second.isRight(), isTrue);
    expect(remoteDataSource.getVideosCalls, 1);
  });

  test('isolates cache by pageSize and cefr filter', () async {
    final res10 = await repository.getVideos(page: 1, pageSize: 10);
    final res20 = await repository.getVideos(page: 1, pageSize: 20);
    final resB1 = await repository.getVideos(page: 1, pageSize: 20, cefr: 'b1');
    final resB1Cached = await repository.getVideos(page: 1, pageSize: 20, cefr: 'B1');

    expect(res10.getOrElse((_) => throw StateError('')).items.length, 10);
    expect(res20.getOrElse((_) => throw StateError('')).items.length, 20);
    expect(resB1.getOrElse((_) => throw StateError('')).items.first.cefrLevel, 'b1');
    expect(resB1Cached.isRight(), isTrue);
    expect(remoteDataSource.getVideosCalls, 3);
  });

  test('refetches from remote after TTL expires', () async {
    await repository.getVideos(page: 1, pageSize: 20);
    currentTime = currentTime.add(const Duration(minutes: 3));
    await repository.getVideos(page: 1, pageSize: 20);

    expect(remoteDataSource.getVideosCalls, 2);
  });

  test('forceRefresh bypasses valid cache and updates cached result', () async {
    await repository.getVideos(page: 1, pageSize: 20);
    remoteDataSource.onGetVideos = ({required page, required pageSize, cefr}) =>
        PaginatedVideoResponseModel(
          items: [
            VideoModel(
              id: 'fresh-1',
              youtubeVideoId: 'yt-fresh',
              title: 'Fresh Video',
              thumbnailUrl: 'https://example.com/fresh.jpg',
              category: 'tech',
              cefrLevel: 'b1',
              publishedAt: DateTime(2026, 1, 1),
              breakingBadge: false,
            ),
          ],
          page: 1,
          pageSize: 20,
          totalItems: 1,
          totalPages: 1,
        );

    final refreshed = await repository.getVideos(
      page: 1,
      pageSize: 20,
      forceRefresh: true,
    );

    expect(remoteDataSource.getVideosCalls, 2);
    expect(
      refreshed.getOrElse((_) => throw StateError('')).items.single.id,
      'fresh-1',
    );
  });

  test('forceRefresh does not fall back to stale cache when remote fails', () async {
    await repository.getVideos(page: 1, pageSize: 20);
    expect(remoteDataSource.getVideosCalls, 1);

    // Expire TTL so normal call hits remote and exercises stale-cache fallback on error.
    currentTime = currentTime.add(const Duration(minutes: 4));
    remoteDataSource.errorToThrow = ServerException('Network offline');

    final normalFallback = await repository.getVideos(
      page: 1,
      pageSize: 20,
    );
    expect(normalFallback.isRight(), isTrue);
    expect(remoteDataSource.getVideosCalls, 2);

    final forcedFailure = await repository.getVideos(
      page: 1,
      pageSize: 20,
      forceRefresh: true,
    );
    expect(forcedFailure.isLeft(), isTrue);
    expect(remoteDataSource.getVideosCalls, 3);
    expect(
      forcedFailure.getLeft().toNullable(),
      isA<ServerFailure>().having((f) => f.message, 'message', 'Network offline'),
    );
  });
}

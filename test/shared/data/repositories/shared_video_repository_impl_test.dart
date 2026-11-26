import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_local_data_source.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_remote_data_source.dart';
import 'package:vocabik_app/shared/data/models/video_category_model.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';
import 'package:vocabik_app/shared/data/repositories/shared_video_repository_impl.dart';

class _FakeSharedVideoRemoteDataSource implements SharedVideoRemoteDataSource {
  int getVideosCalls = 0;
  int getTrendingCalls = 0;
  PaginatedVideoResponseModel? Function({
    required int page,
    required int pageSize,
    String? cefr,
  })? onGetVideos;
  Completer<void>? getVideosGate;
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
    String? searchQuery,
    CancelToken? cancelToken,
  }) async {
    getVideosCalls++;
    if (getVideosGate != null) {
      await getVideosGate!.future;
    }
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
    getTrendingCalls++;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return [
      VideoModel(
        id: 'trend-${cefr ?? 'all'}-$getTrendingCalls',
        youtubeVideoId: 'yt-t',
        title: 'Trending',
        thumbnailUrl: 'https://example.com/t.jpg',
        category: 'music',
        cefrLevel: cefr ?? 'b1',
        publishedAt: DateTime(2025, 1, 1),
        breakingBadge: false,
      ),
    ];
  }

  int getCategoriesCalls = 0;
  List<VideoCategoryModel> mockCategories = const [];
  Object? categoriesErrorToThrow;

  @override
  Future<List<VideoCategoryModel>> getCategories() async {
    getCategoriesCalls++;
    if (categoriesErrorToThrow != null) {
      throw categoriesErrorToThrow!;
    }
    return mockCategories;
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

  test('searchQuery bypasses page-1 cache and does not fall back to stale cache', () async {
    await repository.getVideos(page: 1, pageSize: 20);
    expect(remoteDataSource.getVideosCalls, 1);

    await repository.getVideos(page: 1, pageSize: 20, searchQuery: 'nasa');
    await repository.getVideos(page: 1, pageSize: 20, searchQuery: 'nasa');
    expect(remoteDataSource.getVideosCalls, 3);

    remoteDataSource.errorToThrow = ServerException('Search error');
    final searchFailure = await repository.getVideos(
      page: 1,
      pageSize: 20,
      searchQuery: 'nasa',
    );
    expect(searchFailure.isLeft(), isTrue);
  });

  test('RequestCancelledException returns CancelledFailure without falling back to stale cache', () async {
    await repository.getVideos(page: 1, pageSize: 20);
    currentTime = currentTime.add(const Duration(minutes: 4));
    remoteDataSource.errorToThrow = const RequestCancelledException();

    final cancelled = await repository.getVideos(page: 1, pageSize: 20);
    expect(cancelled.getLeft().toNullable(), isA<CancelledFailure>());
  });

  test('PaginatedVideoResponseModel.fromJson parses /public/exercises/search schema', () {
    final model = PaginatedVideoResponseModel.fromJson({
      'items': [
        {
          'id': 'c3c8763f-ad1a-4c43-8369-5475eaed017b',
          'title': 'Who Works at NASA?',
          'thumbnailUrl': 'https://i.ytimg.com/vi/OXkxQbZEn5E/hqdefault.jpg',
          'cefrLevel': 'C1',
          'genre': 'work-career',
          'artist': 'NASA Goddard',
          'durationSeconds': 176,
          'practiced': 0,
          'publishedAt': '2026-11-25T17:03:55.022Z',
        },
      ],
      'totalCount': 43,
      'page': 1,
      'pageSize': 20,
      'hasMore': true,
    });

    final entity = model.toEntity();
    expect(entity.totalItems, 43);
    expect(entity.hasReachedMax, isFalse);
    expect(entity.items.single.category, 'work-career');
    expect(entity.items.single.youtubeVideoId, 'OXkxQbZEn5E');

    final lastPage = PaginatedVideoResponseModel.fromJson({
      'items': const [],
      'totalCount': 43,
      'page': 3,
      'pageSize': 20,
      'hasMore': false,
    }).toEntity();
    expect(lastPage.hasReachedMax, isTrue);

    final emptyCategoryModel = VideoModel.fromJson({
      'id': 'v-empty-cat',
      'title': 'Empty Category',
      'thumbnailUrl': 'https://i.ytimg.com/vi/OXkxQbZEn5E/hqdefault.jpg',
      'category': '',
      'genre': 'science-space',
      'cefrLevel': 'B2',
      'publishedAt': '2026-11-25T17:03:55.022Z',
    });
    expect(emptyCategoryModel.category, 'science-space');
  });

  test('SharedVideoRemoteDataSourceImpl routes search to /public/exercises/search and maps cancel', () async {
    RequestOptions? capturedOptions;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dio.httpClientAdapter = _FakeHttpClientAdapter((options, cancelFuture) async {
      capturedOptions = options;
      if (options.cancelToken?.isCancelled ?? false) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
        );
      }
      return ResponseBody.fromString(
        jsonEncode({
          'items': const [],
          'totalCount': 0,
          'page': 1,
          'pageSize': 20,
          'hasMore': false,
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    final dataSource = SharedVideoRemoteDataSourceImpl(dio);

    await dataSource.getVideos(page: 1, pageSize: 20, searchQuery: '  nasa  ');
    expect(capturedOptions?.path, '/public/exercises/search');
    expect(capturedOptions?.queryParameters['q'], 'nasa');

    await dataSource.getVideos(page: 1, pageSize: 20, searchQuery: '   ');
    expect(capturedOptions?.path, '/public/videos');
    expect(capturedOptions?.queryParameters.containsKey('q'), isFalse);

    final cancelToken = CancelToken()..cancel('user switched filter');
    await expectLater(
      dataSource.getVideos(
        page: 1,
        pageSize: 20,
        searchQuery: 'nasa',
        cancelToken: cancelToken,
      ),
      throwsA(isA<RequestCancelledException>()),
    );
  });

  test('getCategories caches for 10 minutes and falls back to stale cache when offline', () async {
    remoteDataSource.mockCategories = const [
      VideoCategoryModel(
        slug: 'kids',
        label: 'Thiếu nhi',
        shortLabel: 'Thiếu nhi',
        labels: {'en': 'Kids', 'vi': 'Thiếu nhi'},
        shortLabels: {'en': 'Kids', 'vi': 'Thiếu nhi'},
        sortOrder: 170,
      ),
    ];

    final first = await repository.getCategories();
    expect(first.isRight(), isTrue);
    expect(remoteDataSource.getCategoriesCalls, 1);

    currentTime = currentTime.add(const Duration(minutes: 5));
    final second = await repository.getCategories();
    expect(second.isRight(), isTrue);
    expect(remoteDataSource.getCategoriesCalls, 1);

    currentTime = currentTime.add(const Duration(minutes: 6));
    remoteDataSource.categoriesErrorToThrow = ServerException('Offline');
    final staleFallback = await repository.getCategories();
    expect(staleFallback.isRight(), isTrue);
    expect(staleFallback.getOrElse((_) => const []).single.slug, 'kids');
    expect(remoteDataSource.getCategoriesCalls, 2);
  });

  test('SharedVideoRemoteDataSourceImpl.getCategories parses and sorts by sortOrder', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dio.httpClientAdapter = _FakeHttpClientAdapter((options, cancelFuture) async {
      expect(options.path, '/public/categories');
      return ResponseBody.fromString(
        jsonEncode({
          'items': [
            {
              'slug': 'kids',
              'label': 'Thiếu nhi',
              'shortLabel': 'Thiếu nhi',
              'labels': {'en': 'Kids', 'vi': 'Thiếu nhi'},
              'shortLabels': {'en': 'Kids', 'vi': 'Thiếu nhi'},
              'sortOrder': 170,
            },
            {
              'slug': 'music',
              'label': 'Âm nhạc',
              'shortLabel': 'Âm nhạc',
              'labels': {'en': 'Music', 'vi': 'Âm nhạc'},
              'shortLabels': {'en': 'Music', 'vi': 'Âm nhạc'},
              'sortOrder': 10,
            },
          ],
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    final dataSource = SharedVideoRemoteDataSourceImpl(dio);
    final categories = await dataSource.getCategories();
    expect(categories.map((c) => c.slug).toList(), ['music', 'kids']);
    expect(categories.first.toEntity().localizedShortLabel('en'), 'Music');
    expect(categories.first.toEntity().localizedShortLabel('vi'), 'Âm nhạc');
  });

  test('SharedVideoRepositoryImpl persists categories to disk and reads Cache-First on cold start', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localDataSource = SharedVideoLocalDataSourceImpl(prefs);
  test('deduplicates concurrent pageSize=10 request when pageSize=20 is in-flight', () async {
    final gate = Completer<void>();
    remoteDataSource.getVideosGate = gate;

    final f20 = repository.getVideos(page: 1, pageSize: 20);
    final f10 = repository.getVideos(page: 1, pageSize: 10);
    gate.complete();

    final results = await Future.wait([f20, f10]);
    expect(remoteDataSource.getVideosCalls, 1);
    expect(results[0].getOrElse((_) => throw StateError('')).items.length, 20);
    expect(results[1].getOrElse((_) => throw StateError('')).items.length, 10);
  });

  test('caches getTrendingVideos by cefr and bypasses on forceRefresh', () async {
    final first = await repository.getTrendingVideos(cefr: 'b1');
    final second = await repository.getTrendingVideos(cefr: 'B1');
    final other = await repository.getTrendingVideos(cefr: 'a2');
    final forced = await repository.getTrendingVideos(cefr: 'b1', forceRefresh: true);

    expect(remoteDataSource.getTrendingCalls, 3);
    expect(first.getOrElse((_) => throw StateError('')).single.id, 'trend-b1-1');
    expect(second.getOrElse((_) => throw StateError('')).single.id, 'trend-b1-1');
    expect(other.getOrElse((_) => throw StateError('')).single.id, 'trend-a2-2');
    expect(forced.getOrElse((_) => throw StateError('')).single.id, 'trend-b1-3');
  });

  test('persists page 1 and trending snapshots to JsonDiskCache across instances', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final diskCache = JsonDiskCache(prefs);

    final repo1 = SharedVideoRepositoryImpl.withClock(
      remoteDataSource,
      () => currentTime,
      localDataSource: localDataSource,
    );
    remoteDataSource.mockCategories = const [
      VideoCategoryModel(
        slug: 'kids',
        label: 'Thiếu nhi',
        shortLabel: 'Thiếu nhi',
        shortLabels: {'en': 'Kids', 'vi': 'Thiếu nhi'},
        sortOrder: 170,
      ),
    ];

    expect(repo1.getCachedCategories(), isEmpty);
    await repo1.getCategories();
    expect(remoteDataSource.getCategoriesCalls, 1);

    // Simulate cold start with a fresh repository instance sharing the same disk prefs
    final repo2 = SharedVideoRepositoryImpl.withClock(
      remoteDataSource,
      () => currentTime,
      localDataSource: SharedVideoLocalDataSourceImpl(prefs),
    );
    final coldStartCached = repo2.getCachedCategories();
    expect(coldStartCached.single.slug, 'kids');

    // Within 10-minute TTL, getCategories returns disk cache without calling remote
    currentTime = currentTime.add(const Duration(minutes: 5));
    final fromDiskTtl = await repo2.getCategories();
    expect(fromDiskTtl.getOrElse((_) => const []).single.slug, 'kids');
    expect(remoteDataSource.getCategoriesCalls, 1);

    // After TTL expires, offline error still falls back to disk cache
    currentTime = currentTime.add(const Duration(minutes: 6));
    remoteDataSource.categoriesErrorToThrow = ServerException('Offline');
    final offlineFallback = await repo2.getCategories();
    expect(offlineFallback.getOrElse((_) => const []).single.slug, 'kids');
    expect(remoteDataSource.getCategoriesCalls, 2);
  });

  test('SharedVideoLocalDataSourceImpl handles corrupt JSON gracefully', () async {
    SharedPreferences.setMockInitialValues({
      'cached_video_categories_v1': '{not-valid-json',
    });
    final prefs = await SharedPreferences.getInstance();
    final localDataSource = SharedVideoLocalDataSourceImpl(prefs);

    expect(localDataSource.getCachedCategories(), isNull);
  });

  test('getCategories still returns fresh remote data when disk save throws', () async {
    final repo = SharedVideoRepositoryImpl.withClock(
      remoteDataSource,
      () => currentTime,
      localDataSource: _ThrowingSaveLocalDataSource(),
    );
    remoteDataSource.mockCategories = const [
      VideoCategoryModel(
        slug: 'music',
        label: 'Âm nhạc',
        shortLabel: 'Âm nhạc',
        sortOrder: 10,
      ),
    ];

    final result = await repo.getCategories();
    expect(result.isRight(), isTrue);
    expect(result.getOrElse((_) => const []).single.slug, 'music');
    expect(repo.getCachedCategories().single.slug, 'music');
  });
}

class _ThrowingSaveLocalDataSource implements SharedVideoLocalDataSource {
  @override
  List<VideoCategoryModel>? getCachedCategories() => null;

  @override
  DateTime? getCategoriesCachedAt() => null;

  @override
  Future<void> saveCategories(
    List<VideoCategoryModel> categories,
    DateTime cachedAt,
  ) async {
    throw StateError('Disk full');
  }
}

class _FakeHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(
    RequestOptions options,
    Future<void>? cancelFuture,
  ) onFetch;

  _FakeHttpClientAdapter(this.onFetch);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options, cancelFuture);
  }

  @override
  void close({bool force = false}) {}
      diskCache,
    );
    await repo1.getVideos(page: 1, pageSize: 20, cefr: 'b1');
    await repo1.getTrendingVideos(cefr: 'b1');

    final repo2 = SharedVideoRepositoryImpl.withClock(
      remoteDataSource,
      () => currentTime,
      diskCache,
    );
    final cachedVideos = repo2.getCachedVideos(pageSize: 10, cefr: 'B1');
    final cachedTrending = repo2.getCachedTrendingVideos(cefr: 'B1');

    expect(cachedVideos, isNotNull);
    expect(cachedVideos!.items.length, 10);
    expect(cachedTrending, isNotNull);
    expect(cachedTrending!.single.id, 'trend-b1-1');
  });

  test('computes sliced totalPages accurately without clamping to superset totalPages', () async {
    remoteDataSource.onGetVideos = ({required page, required pageSize, cefr}) {
      return PaginatedVideoResponseModel(
        items: List.generate(
          15,
          (i) => VideoModel(
            id: 'v-$i',
            youtubeVideoId: 'yt-$i',
            title: 'Video $i',
            thumbnailUrl: 'https://example.com/$i.jpg',
            category: 'tech',
            cefrLevel: 'b1',
            publishedAt: DateTime(2025, 1, 1),
            breakingBadge: false,
          ),
        ),
        page: 1,
        pageSize: 20,
        totalItems: 15,
        totalPages: 1,
      );
    };

    await repository.getVideos(page: 1, pageSize: 20);
    final sliced10 = await repository.getVideos(page: 1, pageSize: 10);
    final entity10 = sliced10.getOrElse((_) => throw StateError(''));

    expect(entity10.items.length, 10);
    expect(entity10.totalItems, 15);
    expect(entity10.totalPages, 2);
  });
}

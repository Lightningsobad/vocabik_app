import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_config_entity.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_leaderboard_entity.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_streak_entity.dart';
import 'package:vocabik_app/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:vocabik_app/features/daily_challenge/domain/usecases/get_daily_challenge_config_usecase.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/home_repository.dart';
import 'package:vocabik_app/features/home/domain/usecases/get_daily_pick_usecase.dart';
import 'package:vocabik_app/features/home/domain/usecases/get_personalized_slots_usecase.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_challenge_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_challenge_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_challenge_state.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_state.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_state.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';

class _FakeHomeRepository implements HomeRepository {
  Failure? failure;
  DailyPickEntity? cachedDailyPick;
  List<PersonalizedSlotEntity>? cachedSlots;
  int dailyPickCallCount = 0;
  int personalizedCallCount = 0;

  static const sampleDailyPick = DailyPickEntity(
    videoId: 'dp-1',
    title: 'Daily Pick',
    thumbnailUrl: 'https://example.com/dp.jpg',
    cefrLevel: 'B1',
    playerUrl: 'https://example.com/player',
    artist: 'Artist',
    durationSeconds: 120,
    category: 'music',
    practiced: 10,
  );

  static const sampleSlots = [
    PersonalizedSlotEntity(
      position: 1,
      videoId: 'slot-1',
      title: 'Slot 1',
      thumbnailUrl: 'https://example.com/slot.jpg',
      youtubeVideoId: 'yt-slot-1',
      cefrLevel: 'A2',
      durationSeconds: 90,
      category: 'tech',
    ),
  ];

  @override
  DailyPickEntity? getCachedDailyPick() => cachedDailyPick;

  @override
  List<PersonalizedSlotEntity>? getCachedPersonalizedSlots() => cachedSlots;

  @override
  Future<Either<Failure, DailyPickEntity>> getDailyPick({
    bool forceRefresh = false,
  }) async {
    dailyPickCallCount++;
    if (failure != null) return left(failure!);
    return right(sampleDailyPick);
  }

  @override
  Future<Either<Failure, List<PersonalizedSlotEntity>>> getPersonalizedSlots({
    bool forceRefresh = false,
  }) async {
    personalizedCallCount++;
    if (failure != null) return left(failure!);
    return right(sampleSlots);
  }
}

class _FakeSharedVideoRepository implements SharedVideoRepository {
  Failure? failure;
  int trendingCallCount = 0;
  Completer<void>? trendingGate;
  List<VideoEntity> Function(String? cefr)? onGetTrending;

  static final sampleVideos = [
    VideoEntity(
      id: 'trend-1',
      youtubeVideoId: 'yt-trend-1',
      title: 'Trending Video',
      thumbnailUrl: 'https://example.com/trend.jpg',
      category: 'music',
      cefrLevel: 'B1',
      publishedAt: DateTime(2026, 1, 1),
      breakingBadge: false,
    ),
  ];

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    bool forceRefresh = false,
  }) async {
    trendingCallCount++;
    if (trendingGate != null) {
      await trendingGate!.future;
    }
    if (failure != null) return left(failure!);
    if (onGetTrending != null) return right(onGetTrending!(cefr));
    return right(sampleVideos);
  }

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
    return right(
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
  List<VideoCategoryEntity> getCachedCategories() => const [];

  @override
  Future<Either<Failure, List<VideoCategoryEntity>>> getCategories({
    bool forceRefresh = false,
  }) async {
    return right(const []);
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

class _FakeDailyChallengeRepository implements DailyChallengeRepository {
  Failure? failure;
  int configCallCount = 0;

  static const sampleResponse = DailyChallengeResponseEntity(
    challengeConfigured: true,
    participantCount: 42,
  );

  @override
  Future<Either<Failure, DailyChallengeResponseEntity>> getConfig({
    bool forceRefresh = false,
  }) async {
    configCallCount++;
    if (failure != null) return left(failure!);
    return right(sampleResponse);
  }

  @override
  DailyChallengeResponseEntity? getCachedConfig() => null;

  @override
  Future<Either<Failure, List<DailyChallengeLeaderboardItemEntity>>>
      getLeaderboard(String date) async => right(const []);

  @override
  Future<Either<Failure, DailyChallengeStreakEntity>> getStreak() async =>
      const Right(
        DailyChallengeStreakEntity(
          userId: 'u1',
          currentStreak: 0,
          longestStreak: 0,
        ),
      );

  @override
  Future<Either<Failure, String>> submitResult({
    required int scoreAccuracy,
    required int scoreTimeMs,
  }) async => right('ok');
}

void main() {
  group('HomeDailyPickBloc offline refresh', () {
    test('preserves HomeDailyPickLoaded when refresh fails', () async {
      final repo = _FakeHomeRepository();
      final bloc = HomeDailyPickBloc(GetDailyPickUseCase(repo));
      addTearDown(bloc.close);

      bloc.add(const FetchDailyPick());
      await expectLater(bloc.stream, emitsThrough(isA<HomeDailyPickLoaded>()));

      final emittedAfterLoad = <HomeDailyPickState>[];
      final sub = bloc.stream.listen(emittedAfterLoad.add);
      addTearDown(sub.cancel);

      repo.failure = const ServerFailure('Offline');
      bloc.add(const RefreshDailyPick());
      await pumpEventQueue();

      expect(repo.dailyPickCallCount, 2);
      expect(emittedAfterLoad, isEmpty);
      expect(
        bloc.state,
        isA<HomeDailyPickLoaded>()
            .having((s) => s.dailyPick.videoId, 'videoId', 'dp-1'),
      );
    });

    test('emits HomeDailyPickError when refresh fails before load', () async {
      final repo = _FakeHomeRepository()..failure = const ServerFailure('Offline');
      final bloc = HomeDailyPickBloc(GetDailyPickUseCase(repo));
      addTearDown(bloc.close);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeDailyPickError>().having((s) => s.message, 'message', 'Offline'),
        ]),
      );

      bloc.add(const RefreshDailyPick());
      await expectation;
      expect(repo.dailyPickCallCount, 1);
    });
  });

  group('HomePersonalizedBloc offline refresh', () {
    test('preserves HomePersonalizedLoaded when refresh fails', () async {
      final repo = _FakeHomeRepository();
      final bloc = HomePersonalizedBloc(GetPersonalizedSlotsUseCase(repo));
      addTearDown(bloc.close);

      bloc.add(const FetchPersonalizedSlots());
      await expectLater(
        bloc.stream,
        emitsThrough(isA<HomePersonalizedLoaded>()),
      );

      final emittedAfterLoad = <HomePersonalizedState>[];
      final sub = bloc.stream.listen(emittedAfterLoad.add);
      addTearDown(sub.cancel);

      repo.failure = const ServerFailure('Offline');
      bloc.add(const RefreshPersonalizedSlots());
      await pumpEventQueue();

      expect(repo.personalizedCallCount, 2);
      expect(emittedAfterLoad, isEmpty);
      expect(
        bloc.state,
        isA<HomePersonalizedLoaded>()
            .having((s) => s.slots.length, 'slots.length', 1)
            .having((s) => s.slots.first.videoId, 'videoId', 'slot-1'),
      );
    });

    test('emits HomePersonalizedError when refresh fails before load', () async {
      final repo = _FakeHomeRepository()..failure = const ServerFailure('Offline');
      final bloc = HomePersonalizedBloc(GetPersonalizedSlotsUseCase(repo));
      addTearDown(bloc.close);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomePersonalizedError>()
              .having((s) => s.message, 'message', 'Offline'),
        ]),
      );

      bloc.add(const RefreshPersonalizedSlots());
      await expectation;
      expect(repo.personalizedCallCount, 1);
    });
  });

  group('HomeTrendingBloc offline refresh', () {
    test('preserves HomeTrendingLoaded and currentCefr when refresh fails', () async {
      final repo = _FakeSharedVideoRepository();
      final bloc = HomeTrendingBloc(GetTrendingVideosUseCase(repo));
      addTearDown(bloc.close);

      bloc.add(const ChangeTrendingCefrFilter('B1'));
      await expectLater(bloc.stream, emitsThrough(isA<HomeTrendingLoaded>()));

      final emittedAfterLoad = <HomeTrendingState>[];
      final sub = bloc.stream.listen(emittedAfterLoad.add);
      addTearDown(sub.cancel);

      repo.failure = const ServerFailure('Offline');
      bloc.add(const RefreshTrendingVideos());
      await pumpEventQueue();

      expect(repo.trendingCallCount, 2);
      expect(emittedAfterLoad, isEmpty);
      expect(
        bloc.state,
        isA<HomeTrendingLoaded>()
            .having((s) => s.currentCefr, 'currentCefr', 'B1')
            .having((s) => s.videos.length, 'videos.length', 1)
            .having((s) => s.videos.first.id, 'id', 'trend-1'),
      );
    });

    test('emits HomeTrendingError when refresh fails before load', () async {
      final repo = _FakeSharedVideoRepository()
        ..failure = const ServerFailure('Offline');
      final bloc = HomeTrendingBloc(GetTrendingVideosUseCase(repo));
      addTearDown(bloc.close);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeTrendingError>().having((s) => s.message, 'message', 'Offline'),
        ]),
      );

      bloc.add(const RefreshTrendingVideos());
      await expectation;
      expect(repo.trendingCallCount, 1);
    });
  });

  group('HomeDailyChallengeBloc offline refresh', () {
    test('preserves HomeDailyChallengeLoaded when refresh fails', () async {
      final repo = _FakeDailyChallengeRepository();
      final bloc = HomeDailyChallengeBloc(GetDailyChallengeConfigUseCase(repo));
      addTearDown(bloc.close);

      bloc.add(const FetchHomeDailyChallenge());
      await expectLater(
        bloc.stream,
        emitsThrough(isA<HomeDailyChallengeLoaded>()),
      );

      final emittedAfterLoad = <HomeDailyChallengeState>[];
      final sub = bloc.stream.listen(emittedAfterLoad.add);
      addTearDown(sub.cancel);

      repo.failure = const ServerFailure('Offline');
      bloc.add(const RefreshHomeDailyChallenge());
      await pumpEventQueue();

      expect(repo.configCallCount, 2);
      expect(emittedAfterLoad, isEmpty);
      expect(
        bloc.state,
        isA<HomeDailyChallengeLoaded>()
            .having((s) => s.response.participantCount, 'participantCount', 42),
      );
    });

    test(
      'emits HomeDailyChallengeError when refresh fails before load',
      () async {
        final repo = _FakeDailyChallengeRepository()
          ..failure = const ServerFailure('Offline');
        final bloc =
            HomeDailyChallengeBloc(GetDailyChallengeConfigUseCase(repo));
        addTearDown(bloc.close);

        final expectation = expectLater(
          bloc.stream,
          emitsInOrder([
            isA<HomeDailyChallengeError>()
                .having((s) => s.message, 'message', 'Offline'),
          ]),
        );

        bloc.add(const RefreshHomeDailyChallenge());
        await expectation;
        expect(repo.configCallCount, 1);
      },
    );
  });

  group('SWR, generation guard, and refresh completers', () {
    test('HomeDailyPickBloc emits cached snapshot immediately on cold start (SWR)', () async {
      final repo = _FakeHomeRepository()
        ..cachedDailyPick = _FakeHomeRepository.sampleDailyPick
        ..failure = const ServerFailure('Offline');
      final bloc = HomeDailyPickBloc(GetDailyPickUseCase(repo));
      addTearDown(bloc.close);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeDailyPickLoaded>()
              .having((s) => s.dailyPick.videoId, 'videoId', 'dp-1'),
        ]),
      );

      bloc.add(const FetchDailyPick());
      await expectation;
      await pumpEventQueue();

      expect(repo.dailyPickCallCount, 1);
      expect(bloc.state, isA<HomeDailyPickLoaded>());
    });

    test('HomeTrendingBloc ignores stale RefreshTrendingVideos after ChangeTrendingCefrFilter and completes completer', () async {
      final repo = _FakeSharedVideoRepository();
      final bloc = HomeTrendingBloc(GetTrendingVideosUseCase(repo));
      addTearDown(bloc.close);

      bloc.add(const FetchTrendingVideos());
      await expectLater(bloc.stream, emitsThrough(isA<HomeTrendingLoaded>()));

      final refreshGate = Completer<void>();
      repo.trendingGate = refreshGate;
      repo.onGetTrending = (cefr) => [
        VideoEntity(
          id: 'vid-${cefr ?? 'all'}',
          youtubeVideoId: 'yt',
          title: 'Video',
          thumbnailUrl: 'https://example.com/v.jpg',
          category: 'music',
          cefrLevel: cefr ?? 'all',
          publishedAt: DateTime(2026, 1, 1),
          breakingBadge: false,
        ),
      ];

      final refreshCompleter = Completer<void>();
      bloc.add(RefreshTrendingVideos(completer: refreshCompleter));
      await pumpEventQueue();

      // Switch CEFR while refresh is in-flight; release gate for both.
      bloc.add(const ChangeTrendingCefrFilter('B2'));
      refreshGate.complete();
      await refreshCompleter.future;
      await pumpEventQueue();

      expect(refreshCompleter.isCompleted, isTrue);
      expect(
        bloc.state,
        isA<HomeTrendingLoaded>()
            .having((s) => s.currentCefr, 'currentCefr', 'B2')
            .having((s) => s.videos.single.id, 'id', 'vid-B2'),
      );
    });

    test('droppableCompleter completes dropped refresh completer when another refresh is in-flight', () async {
      final repo = _FakeSharedVideoRepository();
      final gate = Completer<void>();
      repo.trendingGate = gate;
      final bloc = HomeTrendingBloc(GetTrendingVideosUseCase(repo));
      addTearDown(bloc.close);

      final firstCompleter = Completer<void>();
      final droppedCompleter = Completer<void>();

      bloc.add(RefreshTrendingVideos(completer: firstCompleter));
      await pumpEventQueue();
      bloc.add(RefreshTrendingVideos(completer: droppedCompleter));
      await pumpEventQueue();

      expect(droppedCompleter.isCompleted, isTrue);
      expect(firstCompleter.isCompleted, isFalse);

      gate.complete();
      await firstCompleter.future;
      expect(repo.trendingCallCount, 1);
    });
  });
}

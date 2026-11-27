import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:vocabik_app/features/home/domain/usecases/get_personalized_slots_usecase.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_challenge_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_challenge_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_event.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_challenge_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_newly_added_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_recommended_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_trending_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class _TestDailyChallengeRepo implements DailyChallengeRepository {
  int calls = 0;
  Completer<Either<Failure, DailyChallengeResponseEntity>>? gate;

  @override
  Future<Either<Failure, DailyChallengeResponseEntity>> getConfig({
    bool forceRefresh = false,
  }) async {
    calls++;
    if (gate != null) return gate!.future;
    return left(const ServerFailure('Offline'));
  }

  @override
  DailyChallengeResponseEntity? getCachedConfig() => null;

  @override
  Future<Either<Failure, List<DailyChallengeLeaderboardItemEntity>>>
      getLeaderboard(String date) async => const Right([]);

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
  }) async =>
      const Right('ok');
}

class _TestHomeRepo implements HomeRepository {
  int personalizedCalls = 0;

  @override
  Future<Either<Failure, DailyPickEntity>> getDailyPick({
    bool forceRefresh = false,
  }) async =>
      left(const ServerFailure('unused'));

  @override
  Future<Either<Failure, List<PersonalizedSlotEntity>>> getPersonalizedSlots({
    bool forceRefresh = false,
  }) async {
    personalizedCalls++;
    return left(const ServerFailure('Offline'));
  }

  @override
  DailyPickEntity? getCachedDailyPick() => null;
}

class _TestVideoRepo implements SharedVideoRepository {
  int getVideosCalls = 0;
  int getTrendingCalls = 0;

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
    getVideosCalls++;
    return left(const ServerFailure('Offline'));
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    bool forceRefresh = false,
  }) async {
    getTrendingCalls++;
    return left(const ServerFailure('Offline'));
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

Widget _wrapApp(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(extensions: [AppColorsExtension.dark]),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets(
    'DailyChallengeCard shows shimmer when loading without fake Night Changes text',
    (tester) async {
      final gate = Completer<Either<Failure, DailyChallengeResponseEntity>>();
      final repo = _TestDailyChallengeRepo()..gate = gate;
      final bloc = HomeDailyChallengeBloc(GetDailyChallengeConfigUseCase(repo))
        ..add(const FetchHomeDailyChallenge());

      await tester.pumpWidget(
        _wrapApp(
          BlocProvider<HomeDailyChallengeBloc>(
            create: (_) => bloc,
            child: const DailyChallengeCard(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppShimmer), findsOneWidget);
      expect(find.textContaining('Night Changes'), findsNothing);

      gate.complete(
        const Right(DailyChallengeResponseEntity(challengeConfigured: false)),
      );
      await tester.pump();
    },
  );

  testWidgets(
    'DailyChallengeCard shows error and Retry button instead of fake Night Changes',
    (tester) async {
      final repo = _TestDailyChallengeRepo();
      final bloc = HomeDailyChallengeBloc(GetDailyChallengeConfigUseCase(repo))
        ..add(const FetchHomeDailyChallenge());

      await tester.pumpWidget(
        _wrapApp(
          BlocProvider<HomeDailyChallengeBloc>(
            create: (_) => bloc,
            child: const DailyChallengeCard(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(repo.calls, 1);
      expect(find.textContaining('Night Changes'), findsNothing);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(repo.calls, 2);
    },
  );

  testWidgets(
    'HomeRecommendedSection shows error and Retry button on HomePersonalizedError',
    (tester) async {
      final repo = _TestHomeRepo();
      final bloc = HomePersonalizedBloc(GetPersonalizedSlotsUseCase(repo))
        ..add(const FetchPersonalizedSlots());

      await tester.pumpWidget(
        _wrapApp(
          BlocProvider<HomePersonalizedBloc>(
            create: (_) => bloc,
            child: const CustomScrollView(slivers: [HomeRecommendedSection()]),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(repo.personalizedCalls, 1);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(repo.personalizedCalls, 2);
    },
  );

  testWidgets(
    'HomeTrendingSection shows error and Retry button on HomeTrendingError',
    (tester) async {
      final repo = _TestVideoRepo();
      final bloc = HomeTrendingBloc(GetTrendingVideosUseCase(repo))
        ..add(const FetchTrendingVideos());

      await tester.pumpWidget(
        _wrapApp(
          BlocProvider<HomeTrendingBloc>(
            create: (_) => bloc,
            child: const CustomScrollView(slivers: [HomeTrendingSection()]),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(repo.getTrendingCalls, 1);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(repo.getTrendingCalls, 2);
    },
  );

  testWidgets(
    'HomeNewlyAddedSection shows error and Retry button on HomeNewlyError',
    (tester) async {
      final repo = _TestVideoRepo();
      final bloc = HomeNewlyBloc(GetVideosUseCase(repo))
        ..add(const FetchNewlyVideos());

      await tester.pumpWidget(
        _wrapApp(
          BlocProvider<HomeNewlyBloc>(
            create: (_) => bloc,
            child: const CustomScrollView(slivers: [HomeNewlyAddedSection()]),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(repo.getVideosCalls, 1);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(repo.getVideosCalls, 2);
    },
  );
}

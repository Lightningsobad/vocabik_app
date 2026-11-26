import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:vocabik_app/features/discover/presentation/screens/discover_screen.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_horizontal_library_section.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_playlist_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_video_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_video_categories_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_video_grid_sliver.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class _FakeVideoRepo implements SharedVideoRepository {
  int getVideosCalls = 0;
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
    String? searchQuery,
    bool forceRefresh = false,
    AppCancelToken? cancelToken,
  }) async {
    getVideosCalls++;
    if (mockFailure != null) return left(mockFailure!);
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

class _FakePlaylistRepo implements PlaylistRepository {
  @override
  Future<Either<Failure, PaginatedResult<PlaylistEntity>>> getPlaylists({
    int page = 1,
    int pageSize = 10,
  }) async {
    return right(
      const PaginatedResult<PlaylistEntity>(
        items: [],
        page: 1,
        pageSize: 10,
        totalItems: 0,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Either<Failure, PlaylistEntity>> getPlaylistDetail(String slug) async {
    return right(const PlaylistEntity(slug: 's', title: 't'));
  }
}

void main() {
  Widget wrapDiscover(DiscoverBloc bloc) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: ThemeData.dark().copyWith(
        extensions: [AppColorsExtension.dark],
      ),
      home: BlocProvider.value(
        value: bloc,
        child: const DiscoverScreenView(),
      ),
    );
  }

  final nasaVideo = VideoEntity(
    id: 'nasa-1',
    youtubeVideoId: 'yt1',
    title: 'NASA Mars Rover',
    thumbnailUrl: 'https://i.ytimg.com/vi/7Gni54puoIg/maxresdefault.jpg',
    category: 'news',
    cefrLevel: 'B2',
    publishedAt: DateTime(2025, 1, 1),
    breakingBadge: false,
  );

  testWidgets(
    'search mode hides browse sections and displays totalCount with SharedVideoGridSliver',
    (tester) async {
      final videoRepo = _FakeVideoRepo()
        ..mockResult = PaginatedResult<VideoEntity>(
          items: [nasaVideo],
          page: 1,
          pageSize: 20,
          totalItems: 43,
          totalPages: 3,
        );
      final playlistRepo = _FakePlaylistRepo();
      final bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(wrapDiscover(bloc));
      bloc.add(DiscoverVideosFetched());
      await tester.pump();
      await tester.pump();

      bloc.add(const DiscoverSearchQueryChanged('nasa'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(HomeVideoSection), findsNothing);
      expect(find.byType(DiscoverHorizontalLibrarySection), findsNothing);
      expect(find.byType(DiscoverPlaylistSection), findsNothing);
      expect(find.byType(SharedVideoGridSliver), findsOneWidget);
      expect(find.text('Found 43 results for "nasa"', findRichText: true), findsOneWidget);
    },
  );

  testWidgets(
    'search mode error hides count header and scrolling does not auto-retry',
    (tester) async {
      final videoRepo = _FakeVideoRepo();
      final playlistRepo = _FakePlaylistRepo();
      final bloc = DiscoverBloc(
        GetVideosUseCase(videoRepo),
        GetTrendingVideosUseCase(videoRepo),
        GetPlaylistsUseCase(playlistRepo),
        GetVideoCategoriesUseCase(videoRepo),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(wrapDiscover(bloc));
      bloc.add(DiscoverVideosFetched());
      await tester.pump();
      await tester.pump();

      videoRepo.mockFailure = const ServerFailure('Offline');
      final callsBeforeSearch = videoRepo.getVideosCalls;
      bloc.add(const DiscoverSearchQueryChanged('nasa'));
      await tester.pump();
      await tester.pump();

      expect(videoRepo.getVideosCalls, callsBeforeSearch + 1);
      expect(find.textContaining('Found 0', findRichText: true), findsNothing);
      expect(find.text('Retry'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pump();
      expect(videoRepo.getVideosCalls, callsBeforeSearch + 1);
    },
  );
}

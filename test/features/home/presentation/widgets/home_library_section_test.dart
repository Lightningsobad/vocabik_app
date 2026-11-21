import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_library_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class _StubVideoRepository implements SharedVideoRepository {
  Completer<Either<Failure, PaginatedResult<VideoEntity>>>? pendingCompleter;
  Either<Failure, PaginatedResult<VideoEntity>>? nextResponse;
  int getVideosCalls = 0;

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
    getVideosCalls++;
    if (pendingCompleter != null) {
      return pendingCompleter!.future;
    }
    return nextResponse ??
        right(
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
}

Widget _buildTestWidget(HomeVideosBloc bloc) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      extensions: [AppColorsExtension.dark],
    ),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider<HomeVideosBloc>(
        create: (_) => bloc,
        child: const CustomScrollView(
          slivers: [
            HomeLibrarySection(),
          ],
        ),
      ),
    ),
  );
}

void main() {
  final sampleVideo = VideoEntity(
    id: '1',
    youtubeVideoId: 'yt1',
    title: 'Sample Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    category: 'tech',
    cefrLevel: 'b1',
    publishedAt: DateTime(2025, 1, 1),
    breakingBadge: false,
  );

  testWidgets(
    'initial loading renders skeleton cards without CircularProgressIndicator',
    (tester) async {
      final repo = _StubVideoRepository()..pendingCompleter = Completer();
      final bloc = HomeVideosBloc(GetVideosUseCase(repo))
        ..add(const FetchVideos());

      await tester.pumpWidget(_buildTestWidget(bloc));
      await tester.pump();

      expect(find.byType(AppShimmer), findsNWidgets(4));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      repo.pendingCompleter!.complete(
        right(
          PaginatedResult<VideoEntity>(
            items: const [],
            page: 1,
            pageSize: 20,
            totalItems: 0,
            totalPages: 1,
          ),
        ),
      );
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  testWidgets(
    'isLoadingMore renders 2 trailing skeleton cards without CircularProgressIndicator',
    (tester) async {
      final repo = _StubVideoRepository()
        ..nextResponse = right(
          PaginatedResult<VideoEntity>(
            items: [sampleVideo],
            page: 1,
            pageSize: 20,
            totalItems: 20,
            totalPages: 2,
          ),
        );
      final bloc = HomeVideosBloc(GetVideosUseCase(repo))
        ..add(const FetchVideos());

      await tester.pumpWidget(_buildTestWidget(bloc));
      await tester.pump();
      await tester.pump();

      repo.pendingCompleter = Completer();
      bloc.add(const FetchVideos());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SharedCourseCard), findsOneWidget);
      expect(find.byType(AppShimmer), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      repo.pendingCompleter!.complete(
        right(
          PaginatedResult<VideoEntity>(
            items: const [],
            page: 2,
            pageSize: 20,
            totalItems: 20,
            totalPages: 2,
          ),
        ),
      );
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  testWidgets(
    'loadMoreError keeps loaded cards visible and retry dispatches FetchVideos',
    (tester) async {
      final repo = _StubVideoRepository()
        ..nextResponse = right(
          PaginatedResult<VideoEntity>(
            items: [sampleVideo],
            page: 1,
            pageSize: 20,
            totalItems: 20,
            totalPages: 2,
          ),
        );
      final bloc = HomeVideosBloc(GetVideosUseCase(repo))
        ..add(const FetchVideos());

      await tester.pumpWidget(_buildTestWidget(bloc));
      await tester.pump();
      await tester.pump();

      repo.nextResponse = left(const ServerFailure('Network error'));
      bloc.add(const FetchVideos());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SharedCourseCard), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      final callsBeforeRetry = repo.getVideosCalls;

      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.pump();

      expect(repo.getVideosCalls, greaterThan(callsBeforeRetry));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );
}

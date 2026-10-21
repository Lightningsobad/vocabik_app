import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/services/share_service.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/features/video_detail/presentation/widgets/video_detail_content_view.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeShareService extends Fake implements ShareService {
  String? sharedLessonVideoId;
  String? lastMessage;

  @override
  String getLessonUrl(String videoId) => 'https://vocabik.com/videos/$videoId';

  @override
  Future<void> shareLesson({
    required String videoId,
    required String message,
    Rect? sharePositionOrigin,
  }) async {
    sharedLessonVideoId = videoId;
    lastMessage = message;
  }
}

class FakeVideoDetailCubit extends Cubit<VideoDetailState> implements VideoDetailCubit {
  FakeVideoDetailCubit(super.initialState);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _buildTestWidget({required Widget child, required VideoDetailCubit cubit}) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    home: Scaffold(
      body: BlocProvider<VideoDetailCubit>.value(
        value: cubit,
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeShareService fakeShareService;

  setUp(() {
    fakeShareService = FakeShareService();
    if (getIt.isRegistered<ShareService>()) {
      getIt.unregister<ShareService>();
    }
    getIt.registerSingleton<ShareService>(fakeShareService);
  });

  tearDown(() {
    if (getIt.isRegistered<ShareService>()) {
      getIt.unregister<ShareService>();
    }
  });

  testWidgets('VideoDetailContentView tapping "Chia sẻ bài này" invokes shareLesson', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final video = VideoEntity(
      id: 'd0a54bcc-69b5-482e-96d9-5f9593f8a8b3',
      title: 'Shape of You',
      youtubeVideoId: 'JGwWNGJdvx8',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      cefrLevel: 'B1',
      category: 'Pop',
      publishedAt: DateTime(2026, 1, 1),
      breakingBadge: false,
      durationSeconds: 240,
    );

    final state = VideoDetailLoaded(
      video: video,
      selectedExerciseType: ExerciseType.multipleChoice,
      selectedVersion: 'v1',
    );

    final cubit = FakeVideoDetailCubit(state);

    await tester.pumpWidget(_buildTestWidget(
      child: VideoDetailContentView(state: state),
      cubit: cubit,
    ));
    await tester.pumpAndSettle();

    final shareButton = find.text('Chia sẻ bài này');
    expect(shareButton, findsOneWidget);

    await tester.ensureVisible(shareButton);
    await tester.pumpAndSettle();

    await tester.tap(shareButton);
    await tester.pumpAndSettle();

    expect(fakeShareService.sharedLessonVideoId, 'd0a54bcc-69b5-482e-96d9-5f9593f8a8b3');
    expect(fakeShareService.lastMessage, contains('Shape of You'));
    expect(fakeShareService.lastMessage, contains('https://vocabik.com/videos/d0a54bcc-69b5-482e-96d9-5f9593f8a8b3'));
  });
}

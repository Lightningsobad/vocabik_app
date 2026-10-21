import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/services/share_service.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/score_card_share_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeShareService extends Fake implements ShareService {
  String? copiedVideoId;
  String? sharedScoreCardVideoId;
  String? lastMessage;

  @override
  String getLessonUrl(String videoId) => 'https://vocabik.com/videos/$videoId';

  @override
  Future<void> copyLessonLink(String videoId) async {
    copiedVideoId = videoId;
  }

  @override
  Future<bool> shareScoreCardImage({
    required String? imageUrl,
    required String videoId,
    required String message,
    Rect? sharePositionOrigin,
  }) async {
    sharedScoreCardVideoId = videoId;
    lastMessage = message;
    return true;
  }
}

Widget _buildTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    home: Scaffold(
      body: SingleChildScrollView(child: child),
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

  group('ScoreCardShareSection Widget Test', () {
    testWidgets('renders share buttons and title', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          ScoreCardShareSection(
            status: ScoreCardStatus.success,
            imageUrl: 'https://api.vocabik.com/image.png',
            videoId: 'v-123',
            videoTitle: 'Test Song',
            accuracyScore: 90,
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chia sẻ'), findsOneWidget);
      expect(find.text('Instagram'), findsOneWidget);
      expect(find.text('Sao chép'), findsOneWidget);
    });

    testWidgets('tapping Copy button invokes copyLessonLink and shows SnackBar', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          ScoreCardShareSection(
            status: ScoreCardStatus.success,
            imageUrl: 'https://api.vocabik.com/image.png',
            videoId: 'v-123',
            videoTitle: 'Test Song',
            accuracyScore: 90,
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final copyButton = find.text('Sao chép');
      await tester.tap(copyButton);
      await tester.pump();

      expect(fakeShareService.copiedVideoId, 'v-123');
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Đã sao chép vào bộ nhớ tạm!'), findsOneWidget);
    });

    testWidgets('tapping Instagram button invokes shareScoreCardImage with localized caption', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          ScoreCardShareSection(
            status: ScoreCardStatus.success,
            imageUrl: 'https://api.vocabik.com/image.png',
            videoId: 'v-123',
            videoTitle: 'Shape of You',
            accuracyScore: 85,
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final instagramButton = find.text('Instagram');
      await tester.tap(instagramButton);
      await tester.pumpAndSettle();

      expect(fakeShareService.sharedScoreCardVideoId, 'v-123');
      expect(fakeShareService.lastMessage, contains('Shape of You'));
      expect(fakeShareService.lastMessage, contains('85%'));
      expect(fakeShareService.lastMessage, contains('https://vocabik.com/videos/v-123'));
    });
  });
}

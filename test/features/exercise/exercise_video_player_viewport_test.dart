// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_video_player_widget.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FakeNavigationDelegate extends PlatformNavigationDelegate {
  FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}
}

class FakeWebViewController extends PlatformWebViewController {
  FakeWebViewController(super.params) : super.implementation();

  @override
  Future<void> loadFile(String absoluteFilePath) async {}

  @override
  Future<void> loadFlutterAsset(String key) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {}

  @override
  Future<void> removeJavaScriptChannel(String javaScriptChannelName) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}

  @override
  Future<void> enableZoom(bool enabled) async {}

  @override
  Future<void> runJavaScript(String javaScript) async {}

  @override
  Future<Object> runJavaScriptReturningResult(String javaScript) async {
    return '';
  }

  @override
  Future<void> setBackgroundColor(Color color) async {}
}

class FakeWebViewWidget extends PlatformWebViewWidget {
  FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(key: ValueKey('fake_web_view'));
  }
}

class FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return FakeNavigationDelegate(params);
  }

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return FakeWebViewController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return FakeWebViewWidget(params);
  }
}

class FakeExerciseCubit extends Cubit<ExerciseState> implements ExerciseCubit {
  FakeExerciseCubit() : super(ExerciseInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    WebViewPlatform.instance = FakeWebViewPlatform();
  });

  group('ExerciseVideoPlayerWidget Viewport and YouTube Params', () {
    test('YoutubePlayerParams correctly carries origin app identifier', () {
      const params = YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        enableCaption: false,
        mute: false,
        origin: 'https://com.snapsofts.vocabik.yt',
        pointerEvents: PointerEvents.initial,
      );

      expect(params.origin, 'https://com.snapsofts.vocabik.yt');
      final map = params.toMap();
      expect(map['origin'], 'https://com.snapsofts.vocabik.yt');
      expect(map['widget_referrer'], 'https://com.snapsofts.vocabik.yt');
    });

    testWidgets('ExerciseVideoPlayerWidget wraps player in ConstrainedBox >= 200x200',
        (tester) async {
      final fakeCubit = FakeExerciseCubit();
      final controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          origin: 'https://com.snapsofts.vocabik.yt',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BlocProvider<ExerciseCubit>.value(
              value: fakeCubit,
              child: SingleChildScrollView(
                child: ExerciseVideoPlayerWidget(
                  controller: controller,
                  videoTitle: 'Test Video',
                  cefrLevel: 'B1',
                ),
              ),
            ),
          ),
        ),
      );

      final constrainedBoxFinder = find.descendant(
        of: find.byType(ExerciseVideoPlayerWidget),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox &&
              widget.constraints.minWidth == 200 &&
              widget.constraints.minHeight == 200,
        ),
      );

      expect(constrainedBoxFinder, findsOneWidget);

      final constrainedBox = tester.widget<ConstrainedBox>(constrainedBoxFinder);
      expect(constrainedBox.constraints.minWidth, 200);
      expect(constrainedBox.constraints.minHeight, 200);

      controller.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 35));

      await fakeCubit.close();
    });

    testWidgets('Landscape mode layout enforces viewport constraints >= 200',
        (tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fakeCubit = FakeExerciseCubit();
      final controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          origin: 'https://com.snapsofts.vocabik.yt',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BlocProvider<ExerciseCubit>.value(
              value: fakeCubit,
              child: Center(
                child: SizedBox(
                  width: 376,
                  child: SingleChildScrollView(
                    child: ExerciseVideoPlayerWidget(
                      controller: controller,
                      videoTitle: 'Test Video Landscape',
                      cefrLevel: 'B2',
                      isLandscape: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final constrainedBoxFinder = find.descendant(
        of: find.byType(ExerciseVideoPlayerWidget),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox &&
              widget.constraints.minWidth == 200 &&
              widget.constraints.minHeight == 200,
        ),
      );

      expect(constrainedBoxFinder, findsOneWidget);

      controller.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 35));

      await fakeCubit.close();
    });
  });
}

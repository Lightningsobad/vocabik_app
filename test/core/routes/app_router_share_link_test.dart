import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/routes/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppRouter Share Link Routes', () {
    test('contains redirect for /videos/:id to /home/video/:id', () {
      final routes = appRouter.configuration.routes.whereType<GoRoute>();
      final videosRoute = routes.firstWhere((r) => r.path == '/videos/:id');

      expect(videosRoute, isNotNull);
      expect(videosRoute.redirect, isNotNull);
    });

    test('contains redirect for /video/:id to /home/video/:id', () {
      final routes = appRouter.configuration.routes.whereType<GoRoute>();
      final videoRoute = routes.firstWhere((r) => r.path == '/video/:id');

      expect(videoRoute, isNotNull);
      expect(videoRoute.redirect, isNotNull);
    });
  });
}

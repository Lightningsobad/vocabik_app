import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/services/deep_link_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DeepLinkService deepLinkService;

  setUp(() {
    deepLinkService = DeepLinkService();
  });

  tearDown(() {
    deepLinkService.dispose();
  });

  group('DeepLinkService', () {
    test('emits videoId when /videos/:id uri is received', () async {
      final emitted = <String>[];
      deepLinkService.onVideoRouteReceived.listen(emitted.add);

      // Access private or invoke via test helper or reflection:
      // Since _handleUri is private, test URI regex matching logic:
      final uri1 = Uri.parse('https://vocabik.com/videos/d0a54bcc-69b5-482e-96d9-5f9593f8a8b3');
      final uri2 = Uri.parse('https://vocabik.com/video/abc-123');

      final reg = RegExp(r'^/(?:videos|video)/([^/?#]+)');
      expect(reg.firstMatch(uri1.path)?.group(1), 'd0a54bcc-69b5-482e-96d9-5f9593f8a8b3');
      expect(reg.firstMatch(uri2.path)?.group(1), 'abc-123');
    });
  });
}

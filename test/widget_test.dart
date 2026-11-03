import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/di/injection.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VocabikApp());
    await tester.pumpAndSettle();

    // Verify that VocabikApp loads properly.
    expect(find.byType(VocabikApp), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/subscription_tab_content.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

void main() {
  testWidgets('renders SubscriptionTabContent without error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: const [AppColorsExtension.light],
        ),
        home: const Scaffold(
          body: SubscriptionTabContent(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SubscriptionTabContent), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/app_navigation_sheet.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

void main() {
  Widget buildTestApp({
    required GoRouter router,
    Locale locale = const Locale('vi'),
  }) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi'), Locale('en')],
      routerConfig: router,
    );
  }

  testWidgets('AppNavigationSheet renders title and all pages in list', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => AppNavigationSheet.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(router: router));
    await tester.pumpAndSettle();

    // Tap to open sheet
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Verify title
    expect(find.text('Tất cả các trang'), findsOneWidget);

    // Verify each screen row exists in Vietnamese
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Khám phá'), findsOneWidget);
    expect(find.text('Tiến độ'), findsOneWidget);
    expect(find.text('Hồ sơ'), findsOneWidget);
    expect(find.text('Thử thách ngày'), findsOneWidget);
    expect(find.text('Xếp hạng'), findsOneWidget);
    expect(find.text('Thành tích'), findsOneWidget);
    expect(find.text('Sổ từ vựng'), findsOneWidget);
    expect(find.text('Điều khoản'), findsOneWidget);
    expect(find.text('Chính sách bảo mật'), findsOneWidget);
  });

  testWidgets('AppNavigationSheet English locale renders correctly', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => AppNavigationSheet.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(router: router, locale: const Locale('en')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('All pages'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Daily Challenge'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Notebook'), findsOneWidget);
    expect(find.text('Terms'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
  });

  testWidgets('AppNavigationSheet tapping close icon dismisses the sheet', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => AppNavigationSheet.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(router: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(AppNavigationSheet), findsOneWidget);

    // Tap X close button
    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();

    expect(find.byType(AppNavigationSheet), findsNothing);
  });

  testWidgets('AppNavigationSheet tapping a row navigates to target route and closes sheet', (tester) async {
    String navigatedRoute = '/';

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => AppNavigationSheet.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/discover',
          builder: (context, state) {
            navigatedRoute = '/discover';
            return const Scaffold(body: Text('Discover Page'));
          },
        ),
      ],
    );

    await tester.pumpWidget(buildTestApp(router: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Tap 'Khám phá'
    await tester.tap(find.text('Khám phá'));
    await tester.pumpAndSettle();

    // Sheet should be dismissed and route navigated
    expect(find.byType(AppNavigationSheet), findsNothing);
    expect(navigatedRoute, equals('/discover'));
    expect(find.text('Discover Page'), findsOneWidget);
  });
}

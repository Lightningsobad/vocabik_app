import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/app_navigation_sheet.dart';
import 'package:vocabik_app/shared/gamification/cubit/gamification_global_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/localization/domain/repositories/localization_repository.dart';
import 'package:vocabik_app/shared/localization/domain/usecases/get_language_usecase.dart';
import 'package:vocabik_app/shared/localization/domain/usecases/save_language_usecase.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/app_header.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/stat_badge.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/theme/domain/repositories/theme_repository.dart';

class FakeThemeRepository implements ThemeRepository {
  @override
  ThemeMode getCachedThemeMode() => ThemeMode.light;

  @override
  Future<ThemeMode> getThemeMode() async => ThemeMode.light;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {}
}

class FakeLocalizationRepository implements LocalizationRepository {
  @override
  Future<String?> getLanguage() async => 'vi';

  @override
  Future<void> saveLanguage(String languageCode) async {}
}

void main() {
  late GamificationGlobalCubit gamificationCubit;
  late LocalizationCubit localizationCubit;
  late ThemeCubit themeCubit;

  setUp(() {
    gamificationCubit = GamificationGlobalCubit();
    final fakeLocRepo = FakeLocalizationRepository();
    localizationCubit = LocalizationCubit(
      GetLanguageUseCase(fakeLocRepo),
      SaveLanguageUseCase(fakeLocRepo),
    );
    themeCubit = ThemeCubit(themeRepository: FakeThemeRepository());
  });

  tearDown(() {
    gamificationCubit.close();
    localizationCubit.close();
    themeCubit.close();
  });

  Widget buildTestWidget({required Widget child, Size screenSize = const Size(375, 812)}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GamificationGlobalCubit>.value(value: gamificationCubit),
        BlocProvider<LocalizationCubit>.value(value: localizationCubit),
        BlocProvider<ThemeCubit>.value(value: themeCubit),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('vi'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi'), Locale('en')],
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Scaffold(
            appBar: child as PreferredSizeWidget,
          ),
        ),
      ),
    );
  }

  testWidgets('AppHeader displays AppShimmer when isLoading is true without overflow', (tester) async {
    gamificationCubit.setLoading(true);

    // Test on standard mobile screen sizes (360x640, 375x812, 393x852)
    for (final size in [const Size(360, 640), const Size(375, 812), const Size(393, 852)]) {
      tester.view.physicalSize = Size(size.width * 2, size.height * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget(
        child: const AppHeader(),
        screenSize: size,
      ));
      await tester.pump();

      expect(find.byType(AppShimmer), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('AppHeader displays StatBadge when isLoading is false without overflow', (tester) async {
    gamificationCubit.updateStats(streak: 7, xp: 1500);

    for (final size in [const Size(360, 640), const Size(375, 812), const Size(393, 852)]) {
      tester.view.physicalSize = Size(size.width * 2, size.height * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget(
        child: const AppHeader(),
        screenSize: size,
      ));
      await tester.pump();

      expect(find.byType(StatBadge), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('AppHeader opens AppNavigationSheet when layoutGrid icon is tapped with null onMenuTap', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      child: const AppHeader(),
    ));
    await tester.pumpAndSettle();

    final layoutGridFinder = find.byIcon(LucideIcons.layoutGrid);
    expect(layoutGridFinder, findsOneWidget);

    await tester.tap(layoutGridFinder);
    await tester.pumpAndSettle();

    expect(find.byType(AppNavigationSheet), findsOneWidget);
    expect(find.text('Tất cả các trang'), findsOneWidget);
  });

  testWidgets('AppHeader triggers custom onMenuTap when provided', (tester) async {
    var tapped = false;
    await tester.pumpWidget(buildTestWidget(
      child: AppHeader(
        onMenuTap: () {
          tapped = true;
        },
      ),
    ));
    await tester.pumpAndSettle();

    final layoutGridFinder = find.byIcon(LucideIcons.layoutGrid);
    expect(layoutGridFinder, findsOneWidget);

    await tester.tap(layoutGridFinder);
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
    expect(find.byType(AppNavigationSheet), findsNothing);
  });


  testWidgets('AppHeader triggers custom onHomeTap when provided', (tester) async {
    var tapped = false;
    await tester.pumpWidget(buildTestWidget(
      child: AppHeader(
        onHomeTap: () {
          tapped = true;
        },
      ),
    ));
    await tester.pumpAndSettle();

    final logoFinder = find.byType(VocabikLogo);
    expect(logoFinder, findsOneWidget);

    await tester.tap(logoFinder);
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('AppHeader navigates to /home when logo is tapped with null onHomeTap', (tester) async {
    String navigatedRoute = '/profile';

    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Scaffold(
            appBar: AppHeader(),
            body: Text('Profile Page'),
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            navigatedRoute = '/home';
            return const Scaffold(body: Text('Home Page'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<GamificationGlobalCubit>.value(value: gamificationCubit),
          BlocProvider<LocalizationCubit>.value(value: localizationCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          locale: const Locale('vi'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi'), Locale('en')],
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final logoFinder = find.byType(VocabikLogo);
    expect(logoFinder, findsOneWidget);

    await tester.tap(logoFinder);
    await tester.pumpAndSettle();

    expect(navigatedRoute, equals('/home'));
    expect(find.text('Home Page'), findsOneWidget);
  });
}

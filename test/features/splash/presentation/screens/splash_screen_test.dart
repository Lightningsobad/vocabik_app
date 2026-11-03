import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/data/models/user_model.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/get_me_use_case.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_progress_bar.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_brand_text.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  String? accessToken;
  String? refreshToken;
  UserModel? user;
  bool skipped = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    user = null;
    skipped = false;
  }

  @override
  String? getAccessToken() => accessToken;

  @override
  String? getRefreshToken() => refreshToken;

  @override
  bool isCefrSkipped() => skipped;

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    this.user = user;
  }

  @override
  UserModel? getUser() => user;

  @override
  Future<void> setCefrSkipped(bool value) async {
    skipped = value;
  }

  @override
  bool isLegalAccepted(String version, {String? userId}) => true;

  @override
  Future<void> setLegalAccepted(String version, {String? userId}) async {}
}

class FakeSignOutUseCase implements SignOutUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGetMeUseCase implements GetMeUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeAuthLocalDataSource fakeLocalDataSource;

  setUp(() {
    fakeLocalDataSource = FakeAuthLocalDataSource();
    if (getIt.isRegistered<AuthLocalDataSource>()) {
      getIt.unregister<AuthLocalDataSource>();
    }
    getIt.registerSingleton<AuthLocalDataSource>(fakeLocalDataSource);

    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    final authBloc = AuthBloc(
      FakeSignOutUseCase(),
      FakeGetMeUseCase(),
      fakeLocalDataSource,
    );
    getIt.registerSingleton<AuthBloc>(authBloc);
  });

  tearDown(() {
    if (getIt.isRegistered<AuthLocalDataSource>()) {
      getIt.unregister<AuthLocalDataSource>();
    }
    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
  });

  Widget buildTestApp({required ThemeData theme, GoRouter? customRouter}) {
    final router = customRouter ??
        GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
            GoRoute(path: '/login', builder: (context, state) => const Scaffold(body: Text('Login Screen Target'))),
            GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Text('Home Screen Target'))),
          ],
        );

    return MaterialApp.router(
      theme: theme,
      routerConfig: router,
    );
  }

  testWidgets('SplashScreen displays VocabikLogo, VocabikBrandText, and AppProgressBar', (tester) async {
    await tester.pumpWidget(buildTestApp(theme: AppTheme.lightTheme));

    expect(find.byType(VocabikLogo), findsOneWidget);
    expect(find.byType(VocabikBrandText), findsOneWidget);
    expect(find.byType(AppProgressBar), findsOneWidget);

    final progressBar = tester.widget<AppProgressBar>(find.byType(AppProgressBar));
    expect(progressBar.height, equals(4.0));
    expect(progressBar.color, equals(AppColorsExtension.light.primaryAccent));
    expect(progressBar.backgroundColor, equals(AppColorsExtension.light.borderSubtle));

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
  });

  testWidgets('SplashScreen has correct background color for Light Theme', (tester) async {
    await tester.pumpWidget(buildTestApp(theme: AppTheme.lightTheme));

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(AppColorsExtension.light.background));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
  });

  testWidgets('SplashScreen has correct background color for Dark Theme', (tester) async {
    await tester.pumpWidget(buildTestApp(theme: AppTheme.darkTheme));

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(AppColorsExtension.dark.background));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
  });

  testWidgets('SplashScreen navigates to /login when user is unauthenticated', (tester) async {
    fakeLocalDataSource.accessToken = null;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Login Screen Target')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );

    // Initial frame shows Splash
    expect(find.byType(SplashScreen), findsOneWidget);

    // Fast-forward 1600ms (1500ms delay + buffer)
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Login Screen Target'), findsOneWidget);
  });

  testWidgets('SplashScreen navigates to /home when user is authenticated with verified email', (tester) async {
    fakeLocalDataSource.accessToken = 'valid_token';
    fakeLocalDataSource.skipped = true;
    fakeLocalDataSource.user = const UserModel(
      id: '1',
      email: 'user@vocabik.com',
      displayName: 'Vocabik User',
      emailVerified: true,
      cefrLevel: 'B2',
      tier: 'FREE',
    );

    // Re-register AuthBloc with initial state having user
    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    final authBloc = AuthBloc(
      FakeSignOutUseCase(),
      FakeGetMeUseCase(),
      fakeLocalDataSource,
    );
    getIt.registerSingleton<AuthBloc>(authBloc);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Screen Target')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen Target'), findsOneWidget);
  });
}

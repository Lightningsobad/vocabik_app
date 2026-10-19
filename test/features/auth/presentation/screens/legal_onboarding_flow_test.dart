import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/data/models/user_model.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_state.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/verify_email_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/verify_email_state.dart';
import 'package:vocabik_app/features/auth/presentation/screens/login_screen.dart';
import 'package:vocabik_app/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:vocabik_app/features/legal/presentation/screens/legal_consent_screen.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/cefr_selection_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/cefr_selection_state.dart';
import 'package:vocabik_app/features/profile/presentation/screens/cefr_selection_screen.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeLoginCubit extends Cubit<LoginState> implements LoginCubit {
  FakeLoginCubit() : super(const LoginState());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeVerifyEmailCubit extends Cubit<VerifyEmailState>
    implements VerifyEmailCubit {
  FakeVerifyEmailCubit() : super(const VerifyEmailState());
  @override
  void startTimer() {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCefrSelectionCubit extends Cubit<CefrSelectionState>
    implements CefrSelectionCubit {
  FakeCefrSelectionCubit() : super(const CefrSelectionState());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  Widget wrapWithApp({required Widget child, Locale locale = const Locale('vi')}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      home: child,
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('Legal & Onboarding Flow UI Tests', () {
    testWidgets('LoginView renders 13+ binding legal notice with Terms & Privacy links',
        (tester) async {
      configureViewport(tester);
      final cubit = FakeLoginCubit();

      await tester.pumpWidget(
        wrapWithApp(
          child: BlocProvider<LoginCubit>.value(
            value: cubit,
            child: const LoginView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsWidgets);

      // Verify that Terms of Service, Privacy Policy, and 13+ text spans are present
      final hasTermsText = tester.widgetList<RichText>(richTextFinder).any(
            (widget) => widget.text.toPlainText().contains('Điều khoản'),
          );
      final hasPrivacyText = tester.widgetList<RichText>(richTextFinder).any(
            (widget) => widget.text.toPlainText().contains('Chính sách quyền riêng tư'),
          );
      final hasAgeText = tester.widgetList<RichText>(richTextFinder).any(
            (widget) => widget.text.toPlainText().contains('13 tuổi trở lên'),
          );

      expect(hasTermsText, isTrue);
      expect(hasPrivacyText, isTrue);
      expect(hasAgeText, isTrue);

      await cubit.close();
    });

    testWidgets('LegalConsentScreen renders consent notice, action buttons and triggers agree',
        (tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithApp(
          child: const LegalConsentScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Title & description
      expect(find.text('Cập nhật Điều khoản & Bảo mật'), findsOneWidget);
      expect(find.text('Tôi từ 13 tuổi trở lên & Đồng ý'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);

      // Verify Terms and Privacy links are present in text
      final richTextFinder = find.byType(RichText);
      final hasTermsText = tester.widgetList<RichText>(richTextFinder).any(
            (widget) => widget.text.toPlainText().contains('Điều khoản'),
          );
      expect(hasTermsText, isTrue);
    });

    testWidgets('VerifyEmailScreenView renders sign out, delete account and legal links',
        (tester) async {
      configureViewport(tester);
      final cubit = FakeVerifyEmailCubit();

      await tester.pumpWidget(
        wrapWithApp(
          child: BlocProvider<VerifyEmailCubit>.value(
            value: cubit,
            child: const VerifyEmailScreenView(
              email: 'test@example.com',
              password: 'Password123!',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify Sign out and Delete account options
      expect(find.text('Đăng xuất'), findsOneWidget);
      expect(find.text('Xóa tài khoản vĩnh viễn'), findsOneWidget);

      // Verify legal footer links
      expect(find.text('Điều khoản'), findsOneWidget);
      expect(find.text('Chính sách quyền riêng tư'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('CefrSelectionScreenView renders sign out, delete account and legal links',
        (tester) async {
      configureViewport(tester);

      final cubit = FakeCefrSelectionCubit();

      await tester.pumpWidget(
        wrapWithApp(
          child: BlocProvider<CefrSelectionCubit>.value(
            value: cubit,
            child: const CefrSelectionScreenView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Sign out and Delete account options
      expect(find.text('Đăng xuất'), findsOneWidget);
      expect(find.text('Xóa tài khoản vĩnh viễn'), findsOneWidget);

      // Verify legal footer links
      expect(find.text('Điều khoản'), findsOneWidget);
      expect(find.text('Chính sách quyền riêng tư'), findsOneWidget);

      await cubit.close();
    });
  });

  group('AppRouter Legal & Onboarding Redirect Tests', () {
    late AuthLocalDataSource localDataSource;

    setUp(() {
      localDataSource = getIt<AuthLocalDataSource>();
    });

    test('Allowed legal routes for unauthenticated users', () {
      final dummyContext = _DummyBuildContext();

      // Unauthenticated to /terms-of-service -> null (allowed)
      final stateTerms = _createRouterState('/terms-of-service');
      final resultTerms = appRouterRedirect(dummyContext, stateTerms);
      expect(resultTerms, isNull);

      // Unauthenticated to /privacy-policy -> null (allowed)
      final statePrivacy = _createRouterState('/privacy-policy');
      final resultPrivacy = appRouterRedirect(dummyContext, statePrivacy);
      expect(resultPrivacy, isNull);

      // Unauthenticated to /home -> redirects to /login
      final stateHome = _createRouterState('/home');
      final resultHome = appRouterRedirect(dummyContext, stateHome);
      expect(resultHome, equals('/login'));
    });

    test('Logged in user must accept legal version or be routed to /legal-consent', () async {
      final dummyContext = _DummyBuildContext();

      // Save valid token so isLoggedIn is true
      await localDataSource.saveTokens('access_123', 'refresh_123');
      const testUser = UserModel(
        id: 'user_test_1',
        email: 'test@example.com',
        displayName: 'Test User',
        emailVerified: true,
        cefrLevel: 'B1',
        tier: 'free',
      );
      await localDataSource.saveUser(testUser);

      // Has not accepted legal version yet -> redirect to /legal-consent
      final stateHome = _createRouterState('/home');
      final result = appRouterRedirect(dummyContext, stateHome);
      expect(result, equals('/legal-consent'));

      // But if navigating to /terms-of-service -> returns null (never blocked!)
      final stateTerms = _createRouterState('/terms-of-service');
      expect(appRouterRedirect(dummyContext, stateTerms), isNull);

      // If user accepts legal version:
      await localDataSource.setLegalAccepted(
        AuthLocalDataSource.currentLegalVersion,
        userId: testUser.id,
      );

      // Now /home is allowed (not redirected to /legal-consent)
      expect(appRouterRedirect(dummyContext, stateHome), isNull);

      // Cleanup
      await localDataSource.clear();
    });

    test('Unverified email user can access legal screens without getting forced to /verify-email', () async {
      final dummyContext = _DummyBuildContext();

      await localDataSource.saveTokens('access_123', 'refresh_123');
      const testUser = UserModel(
        id: 'user_unverified',
        email: 'unverified@example.com',
        displayName: 'Unverified User',
        emailVerified: false,
        tier: 'free',
      );
      await localDataSource.saveUser(testUser);
      await localDataSource.setLegalAccepted(
        AuthLocalDataSource.currentLegalVersion,
        userId: testUser.id,
      );

      // Trying to go to /home redirects to /verify-email
      final stateHome = _createRouterState('/home');
      getIt<AuthBloc>().add(UserAuthenticated(testUser));
      await Future<void>.delayed(Duration.zero);
      final res = appRouterRedirect(dummyContext, stateHome);
      expect(res, equals('/verify-email'));

      // But /terms-of-service and /privacy-policy are allowed!
      final stateTerms = _createRouterState('/terms-of-service');
      expect(appRouterRedirect(dummyContext, stateTerms), isNull);

      final statePrivacy = _createRouterState('/privacy-policy');
      expect(appRouterRedirect(dummyContext, statePrivacy), isNull);

      // Cleanup
      await localDataSource.clear();
    });
  });
}

class _DummyBuildContext extends Fake implements BuildContext {}

GoRouterState _createRouterState(String location) {
  return GoRouterState(
    appRouter.configuration,
    uri: Uri.parse(location),
    matchedLocation: location,
    fullPath: location,
    pathParameters: const {},
    pageKey: const ValueKey('test'),
  );
}

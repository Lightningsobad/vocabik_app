import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/utils/auth_utils.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/data/models/user_model.dart';
import 'package:vocabik_app/features/moderation/presentation/widgets/block_user_dialog.dart';
import 'package:vocabik_app/features/moderation/presentation/widgets/user_action_bottom_sheet.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/dialogs/report_user_dialog.dart';
import 'package:vocabik_app/shared/presentation/widgets/leaderboard/shared_leaderboard_tile.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  UserModel? user;

  @override
  Future<void> clear() async => user = null;

  @override
  String? getAccessToken() => 'token';

  @override
  String? getRefreshToken() => 'refresh';

  @override
  UserModel? getUser() => user;

  @override
  Future<void> init() async {}

  @override
  bool isCefrSkipped() => false;

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {}

  @override
  Future<void> saveUser(UserModel u) async => user = u;

  @override
  Future<void> setCefrSkipped(bool value) async {}

  @override
  bool isLegalAccepted(String version, {String? userId}) => true;

  @override
  Future<void> setLegalAccepted(String version, {String? userId}) async {}
}

Widget createTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('vi')],
    home: Scaffold(body: child),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthLocalDataSource fakeAuthLocalDataSource;

  setUp(() {
    fakeAuthLocalDataSource = FakeAuthLocalDataSource();
    if (getIt.isRegistered<AuthLocalDataSource>()) {
      getIt.unregister<AuthLocalDataSource>();
    }
    getIt.registerSingleton<AuthLocalDataSource>(fakeAuthLocalDataSource);
  });

  tearDown(() {
    if (getIt.isRegistered<AuthLocalDataSource>()) {
      getIt.unregister<AuthLocalDataSource>();
    }
  });

  group('AuthUtils', () {
    test('isCurrentSelf returns false when no user is logged in', () {
      expect(AuthUtils.isCurrentSelf(userId: 'u1', userName: 'John'), isFalse);
    });

    test('isCurrentSelf returns true when userId matches current user', () {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'me_123',
        email: 'me@example.com',
        displayName: 'My Name',
        tier: 'free',
        emailVerified: true,
      );

      expect(AuthUtils.isCurrentSelf(userId: 'me_123'), isTrue);
      expect(AuthUtils.isCurrentSelf(userId: 'other_456'), isFalse);
    });

    test('isCurrentSelf returns false for literal "You" when target has different userId', () {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'me_123',
        email: 'me@example.com',
        displayName: 'Alice',
        tier: 'free',
        emailVerified: true,
      );

      expect(AuthUtils.isCurrentSelf(userId: 'other_456', userName: 'You'), isFalse);
      expect(AuthUtils.isCurrentSelf(userId: 'other_456', userName: 'you'), isFalse);
      expect(AuthUtils.isCurrentSelf(userId: 'other_456', userName: ' YOU '), isFalse);
      expect(AuthUtils.isCurrentSelf(userName: 'You'), isFalse);
    });

    test('isCurrentSelf returns false when target has different userId even if displayName matches current user', () {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'me_123',
        email: 'me@example.com',
        displayName: 'Alice',
        tier: 'free',
        emailVerified: true,
      );

      // Same name, different ID -> MUST be false
      expect(AuthUtils.isCurrentSelf(userId: 'other_456', userName: 'Alice'), isFalse);
      // Same ID -> true
      expect(AuthUtils.isCurrentSelf(userId: 'me_123', userName: 'Alice'), isTrue);
    });

    test('isCurrentSelf falls back to displayName only when userId is omitted', () {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'me_123',
        email: 'me@example.com',
        displayName: 'quang pham',
        tier: 'free',
        emailVerified: true,
      );

      expect(AuthUtils.isCurrentSelf(userName: 'quang pham'), isTrue);
      expect(AuthUtils.isCurrentSelf(userName: 'other person'), isFalse);
    });
  });

  group('Self-action UI prevention', () {
    testWidgets('SharedLeaderboardTile does not open bottom sheet for current user', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'quang pham',
        tier: 'free',
        emailVerified: true,
      );

      await tester.pumpWidget(
        createTestApp(
          const SharedLeaderboardTile(
            rank: 1,
            userId: 'user_self',
            userName: 'quang pham',
            isCurrentUser: false, // Notice false from API, but ID matches
            trailing: Text('100 XP'),
          ),
        ),
      );

      // Verify YOU badge is displayed
      expect(find.text('YOU'), findsOneWidget);

      // Tap on the tile
      await tester.tap(find.text('quang pham'));
      await tester.pumpAndSettle();

      // Verify bottom sheet does NOT open
      expect(find.byType(UserActionBottomSheet), findsNothing);
    });

    testWidgets('UserActionBottomSheet.show does nothing when target is current user', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'quang pham',
        tier: 'free',
        emailVerified: true,
      );

      late BuildContext ctx;
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      await UserActionBottomSheet.show(
        ctx,
        userId: 'user_self',
        userName: 'quang pham',
      );
      await tester.pumpAndSettle();

      expect(find.byType(UserActionBottomSheet), findsNothing);
    });

    testWidgets('ReportUserDialog.show does nothing when target is current user', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'quang pham',
        tier: 'free',
        emailVerified: true,
      );

      late BuildContext ctx;
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      await ReportUserDialog.show(
        ctx,
        targetId: 'user_self',
        userName: 'quang pham',
      );
      await tester.pumpAndSettle();

      expect(find.byType(ReportUserDialog), findsNothing);
    });

    testWidgets('BlockUserDialog.show returns false and does nothing when target is current user', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'quang pham',
        tier: 'free',
        emailVerified: true,
      );

      late BuildContext ctx;
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final result = await BlockUserDialog.show(
        ctx,
        userId: 'user_self',
        userName: 'quang pham',
      );
      await tester.pumpAndSettle();

      expect(result, isFalse);
      expect(find.byType(BlockUserDialog), findsNothing);
    });

    testWidgets('Moderation dialogs guard against empty user/target ID', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'quang pham',
        tier: 'free',
        emailVerified: true,
      );

      late BuildContext ctx;
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      await UserActionBottomSheet.show(ctx, userId: '', userName: 'Alice');
      await ReportUserDialog.show(ctx, targetId: '', userName: 'Alice');
      final blockResult = await BlockUserDialog.show(ctx, userId: '', userName: 'Alice');
      await tester.pumpAndSettle();

      expect(blockResult, isFalse);
      expect(find.byType(UserActionBottomSheet), findsNothing);
      expect(find.byType(ReportUserDialog), findsNothing);
      expect(find.byType(BlockUserDialog), findsNothing);
    });
  });

  group('Other-user moderation paths enabled', () {
    testWidgets('SharedLeaderboardTile opens bottom sheet for other user named "You"', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'Alice',
        tier: 'free',
        emailVerified: true,
      );

      await tester.pumpWidget(
        createTestApp(
          const SharedLeaderboardTile(
            rank: 2,
            userId: 'user_other',
            userName: 'You',
            isCurrentUser: false,
            trailing: Text('80 XP'),
          ),
        ),
      );

      // Verify YOU badge is NOT displayed for other user
      expect(find.text('YOU'), findsNothing);

      // Tap on the tile
      await tester.tap(find.text('You'));
      await tester.pumpAndSettle();

      // Verify bottom sheet OPENS
      expect(find.byType(UserActionBottomSheet), findsOneWidget);
    });

    testWidgets('SharedLeaderboardTile opens bottom sheet for other user with same displayName', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'Alice',
        tier: 'free',
        emailVerified: true,
      );

      await tester.pumpWidget(
        createTestApp(
          const SharedLeaderboardTile(
            rank: 2,
            userId: 'user_other',
            userName: 'Alice',
            isCurrentUser: false,
            trailing: Text('80 XP'),
          ),
        ),
      );

      expect(find.text('YOU'), findsNothing);

      await tester.tap(find.text('Alice'));
      await tester.pumpAndSettle();

      expect(find.byType(UserActionBottomSheet), findsOneWidget);
    });

    testWidgets('ReportUserDialog.show opens for other user named "You" or same displayName', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'Alice',
        tier: 'free',
        emailVerified: true,
      );

      late BuildContext ctx;
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      // Test other user named "You"
      ReportUserDialog.show(ctx, targetId: 'user_other_1', userName: 'You');
      await tester.pumpAndSettle();
      expect(find.byType(ReportUserDialog), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ReportUserDialog), findsNothing);

      // Test other user with same displayName "Alice"
      ReportUserDialog.show(ctx, targetId: 'user_other_2', userName: 'Alice');
      await tester.pumpAndSettle();
      expect(find.byType(ReportUserDialog), findsOneWidget);
    });

    testWidgets('BlockUserDialog.show opens for other user named "You" or same displayName', (tester) async {
      fakeAuthLocalDataSource.user = const UserModel(
        id: 'user_self',
        email: 'self@example.com',
        displayName: 'Alice',
        tier: 'free',
        emailVerified: true,
      );

      late BuildContext ctx;
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      // Test other user named "You"
      BlockUserDialog.show(ctx, userId: 'user_other_1', userName: 'You');
      await tester.pumpAndSettle();
      expect(find.byType(BlockUserDialog), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(BlockUserDialog), findsNothing);

      // Test other user with same displayName "Alice"
      BlockUserDialog.show(ctx, userId: 'user_other_2', userName: 'Alice');
      await tester.pumpAndSettle();
      expect(find.byType(BlockUserDialog), findsOneWidget);
    });
  });
}

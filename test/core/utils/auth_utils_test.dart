import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/utils/auth_utils.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/data/models/user_model.dart';
import 'package:vocabik_app/features/moderation/presentation/widgets/block_user_dialog.dart';
import 'package:vocabik_app/features/moderation/presentation/widgets/user_action_bottom_sheet.dart';
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
    test('isCurrentSelf returns true for literal "You"', () {
      expect(AuthUtils.isCurrentSelf(userName: 'You'), isTrue);
      expect(AuthUtils.isCurrentSelf(userName: 'you'), isTrue);
      expect(AuthUtils.isCurrentSelf(userName: ' YOU '), isTrue);
    });

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

    test('isCurrentSelf returns true when displayName matches current user', () {
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
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SharedLeaderboardTile(
              rank: 1,
              userId: 'user_self',
              userName: 'quang pham',
              isCurrentUser: false, // Notice false from API, but ID matches
              trailing: Text('100 XP'),
            ),
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
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
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
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
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
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
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
  });
}

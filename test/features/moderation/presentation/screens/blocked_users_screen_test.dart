import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/moderation/data/models/block_user_response_model.dart';
import 'package:vocabik_app/features/moderation/data/models/report_response_model.dart';
import 'package:vocabik_app/features/moderation/domain/entities/blocked_user_entity.dart';
import 'package:vocabik_app/features/moderation/domain/repositories/moderation_repository.dart';
import 'package:vocabik_app/features/moderation/presentation/cubit/blocked_users_cubit.dart';
import 'package:vocabik_app/features/moderation/presentation/screens/blocked_users_screen.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class MockModerationRepoForScreen implements ModerationRepository {
  List<BlockedUserEntity> users;
  String? unblockedId;

  MockModerationRepoForScreen({this.users = const []});

  @override
  Future<Either<Failure, List<BlockedUserEntity>>> getBlockedUsers() async {
    return right(users);
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> unblockUser(String targetUserId) async {
    unblockedId = targetUserId;
    return right(
      BlockUserResponseModel(
        success: true,
        targetUserId: targetUserId,
        message: 'Unblocked',
      ),
    );
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> blockUser(String targetUserId) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ReportResponseModel>> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async =>
      throw UnimplementedError();
}

Widget createScreenTestWidget({
  required Widget child,
  ThemeData? theme,
  Locale locale = const Locale('vi'),
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi'), Locale('en')],
    home: child,
  );
}

void main() {
  late MockModerationRepoForScreen mockRepo;

  setUp(() {
    mockRepo = MockModerationRepoForScreen();
    if (getIt.isRegistered<ModerationRepository>()) {
      getIt.unregister<ModerationRepository>();
    }
    getIt.registerSingleton<ModerationRepository>(mockRepo);

    if (getIt.isRegistered<BlockedUsersCubit>()) {
      getIt.unregister<BlockedUsersCubit>();
    }
    getIt.registerFactory<BlockedUsersCubit>(() => BlockedUsersCubit(mockRepo));
  });

  tearDown(() {
    if (getIt.isRegistered<BlockedUsersCubit>()) {
      getIt.unregister<BlockedUsersCubit>();
    }
    if (getIt.isRegistered<ModerationRepository>()) {
      getIt.unregister<ModerationRepository>();
    }
  });

  testWidgets('BlockedUsersScreen displays empty state when no users are blocked', (
    tester,
  ) async {
    mockRepo.users = [];

    await tester.pumpWidget(
      createScreenTestWidget(
        child: const BlockedUsersScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Người dùng đã chặn'), findsOneWidget);
    expect(find.text('Bạn chưa chặn người dùng nào.'), findsOneWidget);
  });

  testWidgets('BlockedUsersScreen displays blocked users and allows unblocking', (
    tester,
  ) async {
    mockRepo.users = [
      BlockedUserEntity(
        userId: 'u-101',
        displayName: 'Harasser 1',
        blockedAt: DateTime(2026, 10, 14),
      ),
    ];

    await tester.pumpWidget(
      createScreenTestWidget(
        child: const BlockedUsersScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Harasser 1'), findsOneWidget);
    expect(find.text('Bỏ chặn'), findsOneWidget);

    // Tap Unblock
    await tester.tap(find.text('Bỏ chặn'));
    await tester.pumpAndSettle();

    // Confirm dialog appears
    expect(find.text('Bỏ chặn người dùng?'), findsOneWidget);
    expect(
      find.text('Bạn có chắc chắn muốn bỏ chặn Harasser 1? Người này sẽ có thể tương tác lại với bạn.'),
      findsOneWidget,
    );

    // Confirm unblock
    final confirmBtn = find.widgetWithText(ElevatedButton, 'Bỏ chặn');
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    expect(mockRepo.unblockedId, 'u-101');
    expect(find.text('Đã bỏ chặn Harasser 1.'), findsOneWidget);
  });

  testWidgets('BlockedUsersScreen renders properly in dark theme without overflow', (
    tester,
  ) async {
    mockRepo.users = [
      BlockedUserEntity(
        userId: 'u-102',
        displayName: 'Spam Bot',
        blockedAt: DateTime(2026, 10, 14),
      ),
    ];

    await tester.pumpWidget(
      createScreenTestWidget(
        theme: AppTheme.darkTheme,
        child: const BlockedUsersScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Spam Bot'), findsOneWidget);
    expect(find.text('Bỏ chặn'), findsOneWidget);
  });
}

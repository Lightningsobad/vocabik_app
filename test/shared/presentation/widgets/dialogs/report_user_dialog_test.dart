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
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/dialogs/report_user_dialog.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeModerationRepository implements ModerationRepository {
  String? lastTargetType;
  String? lastTargetId;
  String? lastReason;
  String? lastDetails;
  String? lastBlockedUserId;

  @override
  Future<Either<Failure, ReportResponseModel>> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async {
    lastTargetType = targetType;
    lastTargetId = targetId;
    lastReason = reason;
    lastDetails = details;
    return right(
      const ReportResponseModel(
        success: true,
        reportId: 'test-report-id',
        message: 'Báo cáo của bạn đã được tiếp nhận. Đội ngũ kiểm duyệt sẽ xử lý trong vòng 24 giờ.',
      ),
    );
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> blockUser(String targetUserId) async {
    lastBlockedUserId = targetUserId;
    return right(
      BlockUserResponseModel(
        success: true,
        targetUserId: targetUserId,
        message: 'Đã chặn người dùng thành công.',
      ),
    );
  }

  @override
  Future<Either<Failure, BlockUserResponseModel>> unblockUser(String targetUserId) async {
    return right(
      BlockUserResponseModel(
        success: true,
        targetUserId: targetUserId,
        message: 'Đã bỏ chặn người dùng.',
      ),
    );
  }

  @override
  Future<Either<Failure, List<BlockedUserEntity>>> getBlockedUsers() async {
    return right([]);
  }
}

Widget createTestWidget({required Locale locale, required Widget child}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi'), Locale('en')],
    home: Scaffold(body: child),
  );
}

void main() {
  late FakeModerationRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeModerationRepository();
    if (getIt.isRegistered<ModerationRepository>()) {
      getIt.unregister<ModerationRepository>();
    }
    getIt.registerSingleton<ModerationRepository>(fakeRepository);
  });

  tearDown(() {
    if (getIt.isRegistered<ModerationRepository>()) {
      getIt.unregister<ModerationRepository>();
    }
  });

  testWidgets('ReportUserDialog displays Vietnamese text when locale is vi', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('vi'),
        child: const ReportUserDialog(
          targetId: 'user-1',
          userName: 'NguyenVanA',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Báo cáo người dùng'), findsOneWidget);
    expect(
      find.text('Chọn lý do báo cáo tài khoản “NguyenVanA”:'),
      findsOneWidget,
    );
    expect(find.text('Quảng cáo hoặc tin rác'), findsOneWidget);
    expect(find.text('Hủy'), findsOneWidget);
    expect(find.text('Gửi báo cáo'), findsOneWidget);
  });

  testWidgets('ReportUserDialog displays English text when locale is en', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: const ReportUserDialog(
          targetId: 'user-2',
          userName: 'JohnDoe',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Report user'), findsOneWidget);
    expect(
      find.text('Select a reason for reporting account “JohnDoe”:'),
      findsOneWidget,
    );
    expect(find.text('Spam or advertising content'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Submit report'), findsOneWidget);
  });

  testWidgets('ReportUserDialog allows selecting reason, entering details and submitting with 24h message', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => ReportUserDialog.show(
                context,
                targetId: 'target-123',
                userName: 'Spammer123',
              ),
              child: const Text('Open Dialog'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Report user'), findsOneWidget);

    // Tap second reason (Harassment or bullying)
    await tester.tap(find.text('Harassment or bullying'));
    await tester.pumpAndSettle();

    // Enter details in textfield
    await tester.enterText(find.byType(TextField), 'Constant offensive messages');
    await tester.pumpAndSettle();

    // Tap submit button
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    // Verify repository received parameters
    expect(fakeRepository.lastTargetType, 'user');
    expect(fakeRepository.lastTargetId, 'target-123');
    expect(fakeRepository.lastReason, 'harassment');
    expect(fakeRepository.lastDetails, 'Constant offensive messages');

    // Dialog is dismissed, snackbar is shown, and block prompt appears
    expect(find.text('Block this user?'), findsOneWidget);
    expect(
      find.text(
        'Báo cáo của bạn đã được tiếp nhận. Đội ngũ kiểm duyệt sẽ xử lý trong vòng 24 giờ.',
      ),
      findsOneWidget,
    );
  });
}

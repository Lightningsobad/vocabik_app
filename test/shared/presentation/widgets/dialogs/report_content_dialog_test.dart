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
import 'package:vocabik_app/shared/presentation/widgets/dialogs/report_content_dialog.dart';
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
        reportId: 'test-video-report-id',
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

  testWidgets('ReportContentDialog displays Vietnamese video report title and subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('vi'),
        child: const ReportContentDialog(
          targetId: 'video-123',
          targetTitle: 'Bài học Tiếng Anh cơ bản',
          targetType: 'video',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Báo cáo video'), findsOneWidget);
    expect(
      find.text('Chọn lý do báo cáo video “Bài học Tiếng Anh cơ bản”:'),
      findsOneWidget,
    );
    expect(find.text('Nội dung không phù hợp / 18+'), findsOneWidget);
    expect(find.text('Hủy'), findsOneWidget);
    expect(find.text('Gửi báo cáo'), findsOneWidget);
  });

  testWidgets('ReportContentDialog displays English video report title and subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: const ReportContentDialog(
          targetId: 'video-456',
          targetTitle: 'Basic English Lesson',
          targetType: 'video',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Report video'), findsOneWidget);
    expect(
      find.text('Select a reason for reporting video “Basic English Lesson”:'),
      findsOneWidget,
    );
    expect(find.text('Inappropriate content / 18+'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Submit report'), findsOneWidget);
  });

  testWidgets('ReportContentDialog submits report with targetType video and does NOT show block prompt', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => ReportContentDialog.show(
                context,
                targetId: 'video-789',
                targetTitle: 'Advanced Listening',
                targetType: 'video',
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

    expect(find.text('Report video'), findsOneWidget);

    // Tap third reason (Inappropriate content / 18+)
    await tester.tap(find.text('Inappropriate content / 18+'));
    await tester.pumpAndSettle();

    // Enter details in textfield
    await tester.enterText(find.byType(TextField), 'Violent video content');
    await tester.pumpAndSettle();

    // Tap submit button
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    // Verify repository received parameters for video report
    expect(fakeRepository.lastTargetType, 'video');
    expect(fakeRepository.lastTargetId, 'video-789');
    expect(fakeRepository.lastReason, 'inappropriate_content');
    expect(fakeRepository.lastDetails, 'Violent video content');

    // Dialog is dismissed and 24h snackbar is shown
    expect(
      find.text(
        'Báo cáo của bạn đã được tiếp nhận. Đội ngũ kiểm duyệt sẽ xử lý trong vòng 24 giờ.',
      ),
      findsOneWidget,
    );

    // CRITICAL: Block prompt must NOT appear for video reports
    expect(find.text('Block this user?'), findsNothing);
  });
}

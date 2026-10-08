import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/dialogs/report_user_dialog.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

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
  testWidgets('ReportUserDialog displays Vietnamese text when locale is vi', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('vi'),
        child: const ReportUserDialog(userName: 'NguyenVanA'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Báo cáo người dùng'), findsOneWidget);
    expect(
      find.text('Chọn lý do báo cáo tài khoản “NguyenVanA”:'),
      findsOneWidget,
    );
    expect(
      find.text('Tên hiển thị không phù hợp hoặc phản cảm'),
      findsOneWidget,
    );
    expect(find.text('Hủy'), findsOneWidget);
    expect(find.text('Gửi báo cáo'), findsOneWidget);
  });

  testWidgets('ReportUserDialog displays English text when locale is en', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: const ReportUserDialog(userName: 'JohnDoe'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Report user'), findsOneWidget);
    expect(
      find.text('Select a reason for reporting account “JohnDoe”:'),
      findsOneWidget,
    );
    expect(
      find.text('Inappropriate or offensive display name'),
      findsOneWidget,
    );
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Submit report'), findsOneWidget);
  });

  testWidgets('ReportUserDialog allows selecting reason and submitting', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => ReportUserDialog.show(context, 'Spammer123'),
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

    // Tap second reason
    await tester.tap(find.text('Profile picture violates community guidelines'));
    await tester.pumpAndSettle();

    // Tap submit button
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    // Dialog is dismissed and snackbar is shown
    expect(find.text('Report user'), findsNothing);
    expect(
      find.text(
        'Thank you. Your report has been received and forwarded to our moderation team.',
      ),
      findsOneWidget,
    );
  });
}

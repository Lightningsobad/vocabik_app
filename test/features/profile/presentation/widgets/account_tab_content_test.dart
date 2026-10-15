import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/account_tab_content.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  Widget createWidgetUnderTest({
    ThemeData? theme,
    Locale locale = const Locale('vi'),
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
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
        home: const Scaffold(
          body: AccountTabContent(),
        ),
      ),
    );
  }

  testWidgets('renders Delete Account button in Light Theme with correct theme colors', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(theme: AppTheme.lightTheme));
    await tester.pumpAndSettle();

    final lightColors = AppColorsExtension.light;
    expect(lightColors.deleteAccountBorder, const Color(0xFFEDAFBB));
    expect(lightColors.deleteAccountBackground, const Color(0xFFF2E1E9));
    expect(lightColors.deleteAccountText, const Color(0xFFE3465B));

    // Verify Delete Account action item exists with Vietnamese text
    final deleteButtonFinder = find.text('Xóa tài khoản vĩnh viễn');
    expect(deleteButtonFinder, findsOneWidget);

    // Verify container styling
    final containerFinder = find.ancestor(
      of: deleteButtonFinder,
      matching: find.byType(Container),
    ).first;
    final container = tester.widget<Container>(containerFinder);
    final boxDecoration = container.decoration as BoxDecoration;
    expect(boxDecoration.color, lightColors.deleteAccountBackground);
    expect((boxDecoration.border as Border).top.color, lightColors.deleteAccountBorder);
  });

  testWidgets('renders Delete Account button in Dark Theme with correct theme colors', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(theme: AppTheme.darkTheme));
    await tester.pumpAndSettle();

    final darkColors = AppColorsExtension.dark;
    expect(darkColors.deleteAccountBorder, const Color(0xFF732E3E));
    expect(darkColors.deleteAccountBackground, const Color(0xFF331A27));
    expect(darkColors.deleteAccountText, const Color(0xFFF5586D));

    final deleteButtonFinder = find.text('Xóa tài khoản vĩnh viễn');
    expect(deleteButtonFinder, findsOneWidget);

    final containerFinder = find.ancestor(
      of: deleteButtonFinder,
      matching: find.byType(Container),
    ).first;
    final container = tester.widget<Container>(containerFinder);
    final boxDecoration = container.decoration as BoxDecoration;
    expect(boxDecoration.color, darkColors.deleteAccountBackground);
    expect((boxDecoration.border as Border).top.color, darkColors.deleteAccountBorder);
  });

  testWidgets('renders English translations when locale is en', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Delete account permanently'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('tapping Delete Account button opens DeleteAccountConfirmationDialog', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final deleteButtonFinder = find.text('Xóa tài khoản vĩnh viễn');
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();

    // Verify dialog opened
    expect(find.byType(DeleteAccountConfirmationDialog), findsOneWidget);
    expect(find.text('Xóa tài khoản của bạn?'), findsOneWidget);
    expect(find.text('Hủy'), findsOneWidget);
    expect(find.text('Xác nhận xóa tài khoản'), findsOneWidget);
    expect(find.text('Mật khẩu xác nhận'), findsOneWidget);

    // Tap cancel closes dialog
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(find.byType(DeleteAccountConfirmationDialog), findsNothing);
  });
}

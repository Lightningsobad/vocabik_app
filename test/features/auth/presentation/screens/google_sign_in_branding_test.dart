import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_state.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_event.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_state.dart';
import 'package:vocabik_app/features/auth/presentation/screens/login_screen.dart';
import 'package:vocabik_app/features/auth/presentation/screens/register_screen.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeLoginCubit extends Cubit<LoginState> implements LoginCubit {
  FakeLoginCubit() : super(const LoginState());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeRegisterBloc extends Bloc<RegisterEvent, RegisterState>
    implements RegisterBloc {
  FakeRegisterBloc() : super(const RegisterState());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget wrapWithApp({required Widget child}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  group('Google Sign-In Branding Standardization', () {
    testWidgets('LoginView renders official Google SVG asset and no raw G text',
        (tester) async {
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

      // Verify no raw Text('G')
      final rawGText = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'G',
      );
      expect(rawGText, findsNothing);

      // Verify SvgPicture with Google asset
      final googleSvgFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader is SvgAssetLoader &&
            (widget.bytesLoader as SvgAssetLoader).assetName ==
                'assets/auth_screen/google-icon-logo-svgrepo-com.svg',
      );
      expect(googleSvgFinder, findsOneWidget);

      await cubit.close();
    });

    testWidgets(
        'RegisterScreenView renders official Google SVG asset and no raw G text',
        (tester) async {
      final bloc = FakeRegisterBloc();

      await tester.pumpWidget(
        wrapWithApp(
          child: BlocProvider<RegisterBloc>.value(
            value: bloc,
            child: const RegisterScreenView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no raw Text('G')
      final rawGText = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'G',
      );
      expect(rawGText, findsNothing);

      // Verify SvgPicture with Google asset
      final googleSvgFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader is SvgAssetLoader &&
            (widget.bytesLoader as SvgAssetLoader).assetName ==
                'assets/auth_screen/google-icon-logo-svgrepo-com.svg',
      );
      expect(googleSvgFinder, findsOneWidget);

      await bloc.close();
    });
  });
}

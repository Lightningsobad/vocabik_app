import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_state.dart';
import 'package:vocabik_app/shared/settings/cubit/sound_settings_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  testWidgets('ProfileScreen switches to Preferences tab', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ThemeCubit>()),
          BlocProvider(create: (_) => getIt<LocalizationCubit>()..initLanguage()),
          BlocProvider(create: (_) => getIt<SoundSettingsCubit>()),
          BlocProvider(create: (_) => getIt<AuthBloc>()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LocalizationCubit, LocalizationState>(
              builder: (context, localizationState) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  locale: localizationState.currentLocale,
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
                  home: const ProfileScreen(),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap on Preferences tab (Index 1)
    // In VI: 'Tùy chỉnh' or find text
    final l10n = AppLocalizations.of(tester.element(find.byType(ProfileScreen)))!;
    final prefTabFinder = find.text(l10n.preferencesTab);
    expect(prefTabFinder, findsOneWidget);

    await tester.tap(prefTabFinder);
    await tester.pumpAndSettle();

    // Verify preferences content is rendered
    expect(find.text(l10n.appearance), findsOneWidget);
    expect(find.text(l10n.soundDuringExercise), findsOneWidget);
    expect(find.text(l10n.interfaceLanguage), findsOneWidget);
  });
}

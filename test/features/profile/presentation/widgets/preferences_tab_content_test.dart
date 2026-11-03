import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_state.dart';
import 'package:vocabik_app/shared/settings/cubit/sound_settings_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/preferences_tab_content.dart';
import 'package:vocabik_app/core/di/injection.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  testWidgets('PreferencesTabContent renders and interacts without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ThemeCubit>()),
          BlocProvider(
            create: (_) => getIt<LocalizationCubit>()..initLanguage(),
          ),
          BlocProvider(create: (_) => getIt<SoundSettingsCubit>()),
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
                  supportedLocales: const [Locale('vi'), Locale('en')],
                  home: const Scaffold(body: PreferencesTabContent()),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PreferencesTabContent), findsOneWidget);
  });
}

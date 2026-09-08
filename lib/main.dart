import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_state.dart';
import 'package:vocabik_app/shared/settings/cubit/sound_settings_cubit.dart';
import 'package:vocabik_app/shared/gamification/cubit/gamification_global_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/main_shell/presentation/cubit/main_shell_cubit.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/services/deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await configureDependencies();

  // Initialize Deep Links
  final deepLinkService = getIt<DeepLinkService>();
  deepLinkService.init();
  deepLinkService.onTokenReceived.listen((token) {
    appRouter.go('/verify-email', extra: {'token': token});
  });
  deepLinkService.onResetPasswordTokenReceived.listen((token) {
    appRouter.go('/reset-password', extra: {'token': token});
  });

  runApp(const VocabikApp());
}

class VocabikApp extends StatelessWidget {
  const VocabikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<LocalizationCubit>()..initLanguage()),
        BlocProvider(create: (_) => getIt<SoundSettingsCubit>()),
        BlocProvider(create: (_) {
          final bloc = getIt<AuthBloc>();
          if (getIt<AuthLocalDataSource>().getAccessToken() != null) {
            bloc.add(const AuthCheckRequested());
          }
          return bloc;
        }),
        BlocProvider(create: (_) => getIt<GamificationGlobalCubit>()),
        BlocProvider(create: (_) => getIt<MainShellCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocalizationCubit, LocalizationState>(
            builder: (context, localizationState) {
              return MaterialApp.router(
                title: 'Vocabik',
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
                routerConfig: appRouter,
              );
            },
          );
        },
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/data_sources/auth_local_data_source.dart'
    as _i606;
import '../../features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i25;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../shared/localization/cubit/localization_cubit.dart' as _i97;
import '../../shared/localization/data/datasources/localization_local_data_source.dart'
    as _i729;
import '../../shared/localization/data/repositories/localization_repository_impl.dart'
    as _i682;
import '../../shared/localization/domain/repositories/localization_repository.dart'
    as _i960;
import '../../shared/localization/domain/usecases/get_language_usecase.dart'
    as _i738;
import '../../shared/localization/domain/usecases/save_language_usecase.dart'
    as _i476;
import '../../shared/settings/cubit/sound_settings_cubit.dart' as _i521;
import '../../shared/settings/data/datasources/settings_local_data_source.dart'
    as _i431;
import '../../shared/settings/data/repositories/settings_repository.dart'
    as _i520;
import '../../shared/settings/data/repositories/settings_repository_impl.dart'
    as _i668;
import '../../shared/theme/cubit/theme_cubit.dart' as _i909;
import '../../shared/theme/data/repositories/theme_repository_impl.dart'
    as _i108;
import '../../shared/theme/domain/repositories/theme_repository.dart' as _i416;
import 'app_module.dart' as _i461;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i25.AuthRemoteDataSource>(
      () => _i25.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i416.ThemeRepository>(
      () => _i108.ThemeRepositoryImpl(prefs: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i431.SettingsLocalDataSource>(
      () => _i431.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i606.AuthLocalDataSource>(
      () => _i606.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i729.LocalizationLocalDataSource>(
      () =>
          _i729.LocalizationLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i909.ThemeCubit>(
      () => _i909.ThemeCubit(themeRepository: gh<_i416.ThemeRepository>()),
    );
    gh.lazySingleton<_i520.SettingsRepository>(
      () => _i668.SettingsRepositoryImpl(gh<_i431.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i25.AuthRemoteDataSource>(),
        gh<_i606.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i131.SignOutUseCase>(
      () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () =>
          _i797.AuthBloc(gh<_i1038.LoginUseCase>(), gh<_i131.SignOutUseCase>()),
    );
    gh.lazySingleton<_i960.LocalizationRepository>(
      () => _i682.LocalizationRepositoryImpl(
        gh<_i729.LocalizationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i738.GetLanguageUseCase>(
      () => _i738.GetLanguageUseCase(gh<_i960.LocalizationRepository>()),
    );
    gh.lazySingleton<_i476.SaveLanguageUseCase>(
      () => _i476.SaveLanguageUseCase(gh<_i960.LocalizationRepository>()),
    );
    gh.factory<_i521.SoundSettingsCubit>(
      () => _i521.SoundSettingsCubit(gh<_i520.SettingsRepository>()),
    );
    gh.singleton<_i97.LocalizationCubit>(
      () => _i97.LocalizationCubit(
        gh<_i738.GetLanguageUseCase>(),
        gh<_i476.SaveLanguageUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i461.AppModule {}

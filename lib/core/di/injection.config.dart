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
import '../../features/auth/domain/use_cases/get_me_use_case.dart' as _i477;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1010;
import '../../features/auth/domain/use_cases/resend_email_use_case.dart'
    as _i518;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/domain/use_cases/verify_email_use_case.dart'
    as _i421;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/auth/presentation/bloc/register_bloc.dart' as _i690;
import '../../features/auth/presentation/bloc/verify_email_cubit.dart' as _i219;
import '../../features/home/data/datasources/video_remote_data_source.dart'
    as _i706;
import '../../features/home/data/repositories/video_repository_impl.dart'
    as _i1051;
import '../../features/home/domain/repositories/video_repository.dart' as _i637;
import '../../features/home/domain/usecases/get_videos_usecase.dart' as _i694;
import '../../features/home/presentation/bloc/home_videos_bloc.dart' as _i294;
import '../../features/profile/data/data_sources/profile_remote_data_source.dart'
    as _i1012;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/use_cases/update_profile_use_case.dart'
    as _i186;
import '../../features/profile/presentation/cubit/cefr_selection_cubit.dart'
    as _i498;
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
import '../services/deep_link_service.dart' as _i391;
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
    gh.singleton<_i391.DeepLinkService>(() => _i391.DeepLinkService());
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
    gh.lazySingleton<_i361.Dio>(
      () => appModule.dio(gh<_i606.AuthLocalDataSource>()),
    );
    gh.lazySingleton<_i520.SettingsRepository>(
      () => _i668.SettingsRepositoryImpl(gh<_i431.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i960.LocalizationRepository>(
      () => _i682.LocalizationRepositoryImpl(
        gh<_i729.LocalizationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i706.VideoRemoteDataSource>(
      () => _i706.VideoRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i25.AuthRemoteDataSource>(
      () => _i25.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i637.VideoRepository>(
      () => _i1051.VideoRepositoryImpl(
        remoteDataSource: gh<_i706.VideoRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i738.GetLanguageUseCase>(
      () => _i738.GetLanguageUseCase(gh<_i960.LocalizationRepository>()),
    );
    gh.lazySingleton<_i476.SaveLanguageUseCase>(
      () => _i476.SaveLanguageUseCase(gh<_i960.LocalizationRepository>()),
    );
    gh.lazySingleton<_i1012.ProfileRemoteDataSource>(
      () => _i1012.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(gh<_i1012.ProfileRemoteDataSource>()),
    );
    gh.factory<_i521.SoundSettingsCubit>(
      () => _i521.SoundSettingsCubit(gh<_i520.SettingsRepository>()),
    );
    gh.factory<_i694.GetVideosUseCase>(
      () => _i694.GetVideosUseCase(gh<_i637.VideoRepository>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i25.AuthRemoteDataSource>(),
        gh<_i606.AuthLocalDataSource>(),
      ),
    );
    gh.singleton<_i97.LocalizationCubit>(
      () => _i97.LocalizationCubit(
        gh<_i738.GetLanguageUseCase>(),
        gh<_i476.SaveLanguageUseCase>(),
      ),
    );
    gh.factory<_i1010.RegisterUseCase>(
      () => _i1010.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i518.ResendEmailUseCase>(
      () => _i518.ResendEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i131.SignOutUseCase>(
      () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i421.VerifyEmailUseCase>(
      () => _i421.VerifyEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i477.GetMeUseCase>(
      () => _i477.GetMeUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i186.UpdateProfileUseCase>(
      () => _i186.UpdateProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i690.RegisterBloc>(
      () => _i690.RegisterBloc(gh<_i1010.RegisterUseCase>()),
    );
    gh.factory<_i294.HomeVideosBloc>(
      () => _i294.HomeVideosBloc(gh<_i694.GetVideosUseCase>()),
    );
    gh.lazySingleton<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i1038.LoginUseCase>(),
        gh<_i131.SignOutUseCase>(),
        gh<_i477.GetMeUseCase>(),
      ),
    );
    gh.factory<_i219.VerifyEmailCubit>(
      () => _i219.VerifyEmailCubit(
        gh<_i421.VerifyEmailUseCase>(),
        gh<_i518.ResendEmailUseCase>(),
        gh<_i1038.LoginUseCase>(),
        gh<_i131.SignOutUseCase>(),
      ),
    );
    gh.factory<_i498.CefrSelectionCubit>(
      () => _i498.CefrSelectionCubit(gh<_i186.UpdateProfileUseCase>()),
    );
    return this;
  }
}

class _$AppModule extends _i461.AppModule {}

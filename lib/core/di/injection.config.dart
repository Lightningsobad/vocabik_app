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
import '../../features/auth/domain/use_cases/forgot_password_use_case.dart'
    as _i897;
import '../../features/auth/domain/use_cases/get_me_use_case.dart' as _i477;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1010;
import '../../features/auth/domain/use_cases/resend_email_use_case.dart'
    as _i518;
import '../../features/auth/domain/use_cases/reset_password_use_case.dart'
    as _i169;
import '../../features/auth/domain/use_cases/set_cefr_skipped_use_case.dart'
    as _i773;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/domain/use_cases/verify_email_use_case.dart'
    as _i421;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/auth/presentation/bloc/forgot_password_cubit.dart'
    as _i679;
import '../../features/auth/presentation/bloc/login_cubit.dart' as _i281;
import '../../features/auth/presentation/bloc/register_bloc.dart' as _i690;
import '../../features/auth/presentation/bloc/reset_password_cubit.dart'
    as _i165;
import '../../features/auth/presentation/bloc/verify_email_cubit.dart' as _i219;
import '../../features/classroom/data/datasources/classroom_remote_data_source.dart'
    as _i309;
import '../../features/classroom/data/repositories/classroom_repository_impl.dart'
    as _i360;
import '../../features/classroom/domain/repositories/classroom_repository.dart'
    as _i86;
import '../../features/classroom/domain/usecases/create_classroom_use_case.dart'
    as _i822;
import '../../features/classroom/domain/usecases/get_classroom_by_id_use_case.dart'
    as _i5;
import '../../features/classroom/domain/usecases/get_classrooms_use_case.dart'
    as _i851;
import '../../features/classroom/presentation/cubit/classroom_detail_cubit.dart'
    as _i51;
import '../../features/classroom/presentation/cubit/classroom_list_cubit.dart'
    as _i292;
import '../../features/discover/presentation/bloc/discover_bloc.dart' as _i987;
import '../../features/exercise/data/datasources/exercise_remote_datasource.dart'
    as _i913;
import '../../features/exercise/data/datasources/score_card_remote_datasource.dart'
    as _i62;
import '../../features/exercise/data/repositories/exercise_repository_impl.dart'
    as _i607;
import '../../features/exercise/data/repositories/score_card_repository_impl.dart'
    as _i384;
import '../../features/exercise/domain/repositories/exercise_repository.dart'
    as _i50;
import '../../features/exercise/domain/repositories/score_card_repository.dart'
    as _i697;
import '../../features/exercise/domain/usecases/get_exercise_usecase.dart'
    as _i497;
import '../../features/exercise/domain/usecases/submit_progress_usecase.dart'
    as _i6;
import '../../features/exercise/presentation/cubit/exercise_cubit.dart' as _i67;
import '../../features/exercise/presentation/cubit/result_cubit.dart' as _i293;
import '../../features/home/data/datasources/home_remote_data_source.dart'
    as _i362;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/usecases/get_daily_pick_usecase.dart'
    as _i327;
import '../../features/home/domain/usecases/get_personalized_slots_usecase.dart'
    as _i1011;
import '../../features/home/presentation/bloc/home_daily_pick_bloc.dart'
    as _i562;
import '../../features/home/presentation/bloc/home_newly_bloc.dart' as _i850;
import '../../features/home/presentation/bloc/home_personalized_bloc.dart'
    as _i764;
import '../../features/home/presentation/bloc/home_trending_bloc.dart' as _i649;
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
import '../../features/progress/data/data_sources/progress_remote_data_source.dart'
    as _i854;
import '../../features/progress/data/repositories/progress_repository_impl.dart'
    as _i779;
import '../../features/progress/domain/repositories/progress_repository.dart'
    as _i785;
import '../../features/progress/domain/use_cases/get_gamification_summary_use_case.dart'
    as _i474;
import '../../features/progress/presentation/cubit/progress_cubit.dart'
    as _i748;
import '../../features/video_detail/data/datasources/video_detail_remote_data_source.dart'
    as _i268;
import '../../features/video_detail/data/repositories/video_detail_repository_impl.dart'
    as _i272;
import '../../features/video_detail/domain/repositories/video_detail_repository.dart'
    as _i291;
import '../../features/video_detail/domain/use_cases/get_latest_video_progress_use_case.dart'
    as _i209;
import '../../features/video_detail/domain/use_cases/get_video_detail_use_case.dart'
    as _i714;
import '../../features/video_detail/domain/use_cases/get_video_exercise_blanks_use_case.dart'
    as _i203;
import '../../features/video_detail/domain/use_cases/send_video_reaction_use_case.dart'
    as _i241;
import '../../features/video_detail/presentation/cubit/video_detail_cubit.dart'
    as _i483;
import '../../shared/data/datasources/shared_video_remote_data_source.dart'
    as _i967;
import '../../shared/data/repositories/shared_video_repository_impl.dart'
    as _i676;
import '../../shared/domain/repositories/shared_video_repository.dart' as _i959;
import '../../shared/domain/usecases/get_trending_videos_usecase.dart' as _i821;
import '../../shared/domain/usecases/get_videos_usecase.dart' as _i552;
import '../../shared/gamification/cubit/gamification_global_cubit.dart'
    as _i561;
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
    gh.lazySingleton<_i561.GamificationGlobalCubit>(
      () => _i561.GamificationGlobalCubit(),
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
    gh.lazySingleton<_i361.Dio>(
      () => appModule.dio(gh<_i606.AuthLocalDataSource>()),
    );
    gh.lazySingleton<_i967.SharedVideoRemoteDataSource>(
      () => _i967.SharedVideoRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i520.SettingsRepository>(
      () => _i668.SettingsRepositoryImpl(gh<_i431.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i960.LocalizationRepository>(
      () => _i682.LocalizationRepositoryImpl(
        gh<_i729.LocalizationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i959.SharedVideoRepository>(
      () => _i676.SharedVideoRepositoryImpl(
        remoteDataSource: gh<_i967.SharedVideoRemoteDataSource>(),
      ),
    );
    gh.factory<_i821.GetTrendingVideosUseCase>(
      () => _i821.GetTrendingVideosUseCase(gh<_i959.SharedVideoRepository>()),
    );
    gh.factory<_i552.GetVideosUseCase>(
      () => _i552.GetVideosUseCase(gh<_i959.SharedVideoRepository>()),
    );
    gh.factory<_i649.HomeTrendingBloc>(
      () => _i649.HomeTrendingBloc(gh<_i821.GetTrendingVideosUseCase>()),
    );
    gh.factory<_i850.HomeNewlyBloc>(
      () => _i850.HomeNewlyBloc(gh<_i552.GetVideosUseCase>()),
    );
    gh.factory<_i294.HomeVideosBloc>(
      () => _i294.HomeVideosBloc(gh<_i552.GetVideosUseCase>()),
    );
    gh.lazySingleton<_i25.AuthRemoteDataSource>(
      () => _i25.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i854.ProgressRemoteDataSource>(
      () => _i854.ProgressRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i309.ClassroomRemoteDataSource>(
      () => _i309.ClassroomRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i913.ExerciseRemoteDataSource>(
      () => _i913.ExerciseRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i62.ScoreCardRemoteDataSource>(
      () => _i62.ScoreCardRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i268.VideoDetailRemoteDataSource>(
      () => _i268.VideoDetailRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i362.HomeRemoteDataSource>(
      () => _i362.HomeRemoteDataSourceImpl(gh<_i361.Dio>()),
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
    gh.lazySingleton<_i291.VideoDetailRepository>(
      () => _i272.VideoDetailRepositoryImpl(
        gh<_i268.VideoDetailRemoteDataSource>(),
      ),
    );
    gh.factory<_i521.SoundSettingsCubit>(
      () => _i521.SoundSettingsCubit(gh<_i520.SettingsRepository>()),
    );
    gh.factory<_i987.DiscoverBloc>(
      () => _i987.DiscoverBloc(gh<_i552.GetVideosUseCase>()),
    );
    gh.lazySingleton<_i50.ExerciseRepository>(
      () => _i607.ExerciseRepositoryImpl(gh<_i913.ExerciseRemoteDataSource>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i25.AuthRemoteDataSource>(),
        gh<_i606.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i86.ClassroomRepository>(
      () =>
          _i360.ClassroomRepositoryImpl(gh<_i309.ClassroomRemoteDataSource>()),
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
    gh.factory<_i773.SetCefrSkippedUseCase>(
      () => _i773.SetCefrSkippedUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i131.SignOutUseCase>(
      () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i421.VerifyEmailUseCase>(
      () => _i421.VerifyEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i897.ForgotPasswordUseCase>(
      () => _i897.ForgotPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i477.GetMeUseCase>(
      () => _i477.GetMeUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i787.AuthRepository>()),
    );

    gh.lazySingleton<_i169.ResetPasswordUseCase>(
      () => _i169.ResetPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i697.ScoreCardRepository>(
      () => _i384.ScoreCardRepositoryImpl(gh<_i62.ScoreCardRemoteDataSource>()),
    );
    gh.lazySingleton<_i0.HomeRepository>(
      () => _i76.HomeRepositoryImpl(
        remoteDataSource: gh<_i362.HomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i679.ForgotPasswordCubit>(
      () => _i679.ForgotPasswordCubit(gh<_i897.ForgotPasswordUseCase>()),
    );
    gh.factory<_i165.ResetPasswordCubit>(
      () => _i165.ResetPasswordCubit(gh<_i169.ResetPasswordUseCase>()),
    );
    gh.lazySingleton<_i785.ProgressRepository>(
      () => _i779.ProgressRepositoryImpl(gh<_i854.ProgressRemoteDataSource>()),
    );
    gh.factory<_i186.UpdateProfileUseCase>(
      () => _i186.UpdateProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i327.GetDailyPickUseCase>(
      () => _i327.GetDailyPickUseCase(gh<_i0.HomeRepository>()),
    );
    gh.factory<_i1011.GetPersonalizedSlotsUseCase>(
      () => _i1011.GetPersonalizedSlotsUseCase(gh<_i0.HomeRepository>()),
    );
    gh.factory<_i822.CreateClassroomUseCase>(
      () => _i822.CreateClassroomUseCase(gh<_i86.ClassroomRepository>()),
    );
    gh.factory<_i5.GetClassroomByIdUseCase>(
      () => _i5.GetClassroomByIdUseCase(gh<_i86.ClassroomRepository>()),
    );
    gh.factory<_i851.GetClassroomsUseCase>(
      () => _i851.GetClassroomsUseCase(gh<_i86.ClassroomRepository>()),
    );
    gh.factory<_i498.CefrSelectionCubit>(
      () => _i498.CefrSelectionCubit(
        gh<_i186.UpdateProfileUseCase>(),
        gh<_i773.SetCefrSkippedUseCase>(),
      ),
    );
    gh.factory<_i690.RegisterBloc>(
      () => _i690.RegisterBloc(gh<_i1010.RegisterUseCase>()),
    );
    gh.lazySingleton<_i797.AuthBloc>(
      () =>
          _i797.AuthBloc(gh<_i131.SignOutUseCase>(), gh<_i477.GetMeUseCase>()),
    );
    gh.factory<_i292.ClassroomListCubit>(
      () => _i292.ClassroomListCubit(
        gh<_i851.GetClassroomsUseCase>(),
        gh<_i822.CreateClassroomUseCase>(),
      ),
    );
    gh.factory<_i209.GetLatestVideoProgressUseCase>(
      () => _i209.GetLatestVideoProgressUseCase(
        gh<_i291.VideoDetailRepository>(),
      ),
    );
    gh.factory<_i714.GetVideoDetailUseCase>(
      () => _i714.GetVideoDetailUseCase(gh<_i291.VideoDetailRepository>()),
    );
    gh.factory<_i203.GetVideoExerciseBlanksUseCase>(
      () => _i203.GetVideoExerciseBlanksUseCase(
        gh<_i291.VideoDetailRepository>(),
      ),
    );
    gh.factory<_i241.SendVideoReactionUseCase>(
      () => _i241.SendVideoReactionUseCase(gh<_i291.VideoDetailRepository>()),
    );
    gh.factory<_i281.LoginCubit>(
      () => _i281.LoginCubit(gh<_i1038.LoginUseCase>(), gh<_i797.AuthBloc>()),
    );
    gh.factory<_i562.HomeDailyPickBloc>(
      () => _i562.HomeDailyPickBloc(gh<_i327.GetDailyPickUseCase>()),
    );
    gh.factory<_i497.GetExerciseUseCase>(
      () => _i497.GetExerciseUseCase(gh<_i50.ExerciseRepository>()),
    );
    gh.factory<_i6.SubmitProgressUseCase>(
      () => _i6.SubmitProgressUseCase(gh<_i50.ExerciseRepository>()),
    );
    gh.factory<_i764.HomePersonalizedBloc>(
      () =>
          _i764.HomePersonalizedBloc(gh<_i1011.GetPersonalizedSlotsUseCase>()),
    );
    gh.factory<_i483.VideoDetailCubit>(
      () => _i483.VideoDetailCubit(
        gh<_i714.GetVideoDetailUseCase>(),
        gh<_i203.GetVideoExerciseBlanksUseCase>(),
        gh<_i209.GetLatestVideoProgressUseCase>(),
        gh<_i241.SendVideoReactionUseCase>(),
      ),
    );
    gh.lazySingleton<_i474.GetGamificationSummaryUseCase>(
      () => _i474.GetGamificationSummaryUseCase(gh<_i785.ProgressRepository>()),
    );
    gh.factory<_i67.ExerciseCubit>(
      () => _i67.ExerciseCubit(gh<_i497.GetExerciseUseCase>()),
    );
    gh.factory<_i293.ResultCubit>(
      () => _i293.ResultCubit(
        gh<_i697.ScoreCardRepository>(),
        gh<_i6.SubmitProgressUseCase>(),
      ),
    );
    gh.factory<_i51.ClassroomDetailCubit>(
      () => _i51.ClassroomDetailCubit(gh<_i5.GetClassroomByIdUseCase>()),
    );
    gh.factory<_i219.VerifyEmailCubit>(
      () => _i219.VerifyEmailCubit(
        gh<_i421.VerifyEmailUseCase>(),
        gh<_i518.ResendEmailUseCase>(),
        gh<_i1038.LoginUseCase>(),
        gh<_i797.AuthBloc>(),
      ),
    );
    gh.factory<_i748.ProgressCubit>(
      () => _i748.ProgressCubit(
        gh<_i474.GetGamificationSummaryUseCase>(),
        gh<_i561.GamificationGlobalCubit>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i461.AppModule {}

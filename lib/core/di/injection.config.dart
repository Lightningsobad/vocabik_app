// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/achievements/data/datasources/badge_remote_data_source.dart'
    as _i991;
import '../../features/achievements/data/repositories/badge_repository_impl.dart'
    as _i345;
import '../../features/achievements/domain/repositories/badge_repository.dart'
    as _i65;
import '../../features/achievements/domain/usecases/get_badges_usecase.dart'
    as _i467;
import '../../features/achievements/presentation/cubit/achievements_cubit.dart'
    as _i693;
import '../../features/auth/data/data_sources/auth_local_data_source.dart'
    as _i606;
import '../../features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i25;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/delete_account_use_case.dart'
    as _i353;
import '../../features/auth/domain/use_cases/forgot_password_use_case.dart'
    as _i897;
import '../../features/auth/domain/use_cases/get_me_use_case.dart' as _i477;
import '../../features/auth/domain/use_cases/get_sessions_use_case.dart'
    as _i1058;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/login_with_google_use_case.dart'
    as _i490;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1013;
import '../../features/auth/domain/use_cases/resend_email_use_case.dart'
    as _i518;
import '../../features/auth/domain/use_cases/reset_password_use_case.dart'
    as _i169;
import '../../features/auth/domain/use_cases/set_cefr_skipped_use_case.dart'
    as _i774;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/domain/use_cases/verify_email_use_case.dart'
    as _i421;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/auth/presentation/bloc/forgot_password_cubit.dart'
    as _i679;
import '../../features/auth/presentation/bloc/login_cubit.dart' as _i281;
import '../../features/auth/presentation/bloc/register_bloc.dart' as _i691;
import '../../features/auth/presentation/bloc/reset_password_cubit.dart'
    as _i165;
import '../../features/auth/presentation/bloc/verify_email_cubit.dart' as _i219;
import '../../features/challenge_friend/data/datasources/challenge_friend_remote_datasource.dart'
    as _i344;
import '../../features/challenge_friend/data/repositories/challenge_friend_repository_impl.dart'
    as _i594;
import '../../features/challenge_friend/domain/repositories/challenge_friend_repository.dart'
    as _i1011;
import '../../features/challenge_friend/domain/usecases/create_challenge_link_usecase.dart'
    as _i228;
import '../../features/challenge_friend/domain/usecases/get_friends_usecase.dart'
    as _i71;
import '../../features/challenge_friend/presentation/cubit/challenge_friend_cubit.dart'
    as _i719;
import '../../features/daily_challenge/data/datasources/daily_challenge_remote_data_source.dart'
    as _i951;
import '../../features/daily_challenge/data/repositories/daily_challenge_repository_impl.dart'
    as _i617;
import '../../features/daily_challenge/domain/repositories/daily_challenge_repository.dart'
    as _i134;
import '../../features/daily_challenge/domain/usecases/get_daily_challenge_config_usecase.dart'
    as _i155;
import '../../features/daily_challenge/domain/usecases/get_daily_challenge_leaderboard_usecase.dart'
    as _i1016;
import '../../features/daily_challenge/domain/usecases/get_daily_challenge_streak_usecase.dart'
    as _i935;
import '../../features/daily_challenge/domain/usecases/submit_daily_challenge_result_usecase.dart'
    as _i544;
import '../../features/daily_challenge/presentation/bloc/daily_challenge_bloc.dart'
    as _i838;
import '../../features/discover/data/datasources/discover_playlist_remote_data_source.dart'
    as _i287;
import '../../features/discover/data/repositories/playlist_repository_impl.dart'
    as _i899;
import '../../features/discover/domain/repositories/playlist_repository.dart'
    as _i772;
import '../../features/discover/domain/usecases/get_playlist_detail_usecase.dart'
    as _i493;
import '../../features/discover/domain/usecases/get_playlists_usecase.dart'
    as _i880;
import '../../features/discover/presentation/bloc/discover_bloc.dart' as _i987;
import '../../features/discover/presentation/cubit/playlist_detail_cubit.dart'
    as _i690;
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
import '../../features/exercise/domain/usecases/get_video_translations_usecase.dart'
    as _i309;
import '../../features/exercise/domain/usecases/submit_progress_usecase.dart'
    as _i5;
import '../../features/exercise/presentation/cubit/exercise_cubit.dart' as _i67;
import '../../features/exercise/presentation/cubit/result_cubit.dart' as _i292;
import '../../features/home/data/datasources/home_remote_data_source.dart'
    as _i362;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/usecases/get_daily_pick_usecase.dart'
    as _i327;
import '../../features/home/domain/usecases/get_personalized_slots_usecase.dart'
    as _i1010;
import '../../features/home/presentation/bloc/home_daily_challenge_bloc.dart'
    as _i860;
import '../../features/home/presentation/bloc/home_daily_pick_bloc.dart'
    as _i562;
import '../../features/home/presentation/bloc/home_newly_bloc.dart' as _i850;
import '../../features/home/presentation/bloc/home_personalized_bloc.dart'
    as _i764;
import '../../features/home/presentation/bloc/home_trending_bloc.dart' as _i649;
import '../../features/home/presentation/bloc/home_videos_bloc.dart' as _i294;
import '../../features/leaderboard/data/datasources/leaderboard_remote_data_source.dart'
    as _i386;
import '../../features/leaderboard/data/repositories/leaderboard_repository_impl.dart'
    as _i1008;
import '../../features/leaderboard/domain/repositories/leaderboard_repository.dart'
    as _i655;
import '../../features/leaderboard/domain/use_cases/get_xp_leaderboard_use_case.dart'
    as _i970;
import '../../features/leaderboard/presentation/cubit/xp_leaderboard_cubit.dart'
    as _i347;
import '../../features/main_shell/presentation/cubit/main_shell_cubit.dart'
    as _i481;
import '../../features/moderation/data/datasources/moderation_remote_data_source.dart'
    as _i200;
import '../../features/moderation/data/repositories/moderation_repository_impl.dart'
    as _i378;
import '../../features/moderation/domain/repositories/moderation_repository.dart'
    as _i106;
import '../../features/moderation/presentation/cubit/blocked_users_cubit.dart'
    as _i793;
import '../../features/notebook/data/datasources/notebook_remote_data_source.dart'
    as _i828;
import '../../features/notebook/data/repositories/notebook_repository_impl.dart'
    as _i168;
import '../../features/notebook/domain/repositories/notebook_repository.dart'
    as _i718;
import '../../features/notebook/domain/usecases/get_notebook_words_usecase.dart'
    as _i755;
import '../../features/notebook/domain/usecases/update_word_review_status_usecase.dart'
    as _i872;
import '../../features/notebook/presentation/cubit/notebook_cubit.dart'
    as _i720;
import '../../features/profile/data/data_sources/profile_remote_data_source.dart'
    as _i1012;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/use_cases/update_profile_use_case.dart'
    as _i186;
import '../../features/profile/presentation/cubit/active_sessions_cubit.dart'
    as _i312;
import '../../features/profile/presentation/cubit/cefr_selection_cubit.dart'
    as _i498;
import '../../features/profile/presentation/cubit/delete_account_cubit.dart'
    as _i841;
import '../../features/profile/presentation/cubit/update_profile_cubit.dart'
    as _i575;
import '../../features/progress/data/data_sources/progress_remote_data_source.dart'
    as _i854;
import '../../features/progress/data/repositories/progress_repository_impl.dart'
    as _i779;
import '../../features/progress/domain/repositories/progress_repository.dart'
    as _i785;
import '../../features/progress/domain/use_cases/get_progress_error_insights_use_case.dart'
    as _i748;
import '../../features/progress/domain/use_cases/get_progress_history_use_case.dart'
    as _i773;
import '../../features/progress/domain/use_cases/get_progress_summary_use_case.dart'
    as _i74;
import '../../features/progress/presentation/cubit/progress_cubit.dart'
    as _i749;
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
import '../services/analytics_service.dart' as _i222;
import '../services/audio_feedback_service.dart' as _i464;
import '../services/crashlytics_service.dart' as _i352;
import '../services/deep_link_service.dart' as _i391;
import '../services/notification/fcm_service.dart' as _i409;
import '../services/notification/in_app_messaging_service.dart' as _i408;
import '../services/notification/local_notification_service.dart' as _i474;
import '../services/notification/notification_router_handler.dart' as _i961;
import '../services/notification/notification_service.dart' as _i446;
import '../services/social_auth_service.dart' as _i723;
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
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i222.AnalyticsService>(() => appModule.analyticsService);
    gh.lazySingleton<_i352.CrashlyticsService>(
      () => appModule.crashlyticsService,
    );
    gh.lazySingleton<_i961.NotificationRouterHandler>(
      () => appModule.routerHandler,
    );
    gh.lazySingleton<_i408.InAppMessagingService>(
      () => appModule.inAppMessagingService,
    );
    gh.lazySingleton<_i561.GamificationGlobalCubit>(
      () => _i561.GamificationGlobalCubit(),
    );
    gh.lazySingleton<_i606.AuthLocalDataSource>(
      () => _i606.AuthLocalDataSourceImpl(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i416.ThemeRepository>(
      () => _i108.ThemeRepositoryImpl(prefs: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i474.LocalNotificationService>(
      () => appModule.localNotificationService(
        gh<_i961.NotificationRouterHandler>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => appModule.dio(gh<_i606.AuthLocalDataSource>()),
    );
    gh.lazySingleton<_i409.FcmService>(
      () => appModule.fcmService(
        gh<_i474.LocalNotificationService>(),
        gh<_i961.NotificationRouterHandler>(),
      ),
    );
    gh.lazySingleton<_i967.SharedVideoRemoteDataSource>(
      () => _i967.SharedVideoRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i723.SocialAuthService>(
      () => _i723.GoogleAuthServiceImpl(),
    );
    gh.lazySingleton<_i431.SettingsLocalDataSource>(
      () => _i431.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i959.SharedVideoRepository>(
      () => _i676.SharedVideoRepositoryImpl(
        remoteDataSource: gh<_i967.SharedVideoRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i729.LocalizationLocalDataSource>(
      () =>
          _i729.LocalizationLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
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
    gh.lazySingleton<_i446.NotificationService>(
      () => appModule.notificationService(
        gh<_i409.FcmService>(),
        gh<_i474.LocalNotificationService>(),
        gh<_i408.InAppMessagingService>(),
        gh<_i961.NotificationRouterHandler>(),
      ),
    );
    gh.lazySingleton<_i386.LeaderboardRemoteDataSource>(
      () => _i386.LeaderboardRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i200.ModerationRemoteDataSource>(
      () => _i200.ModerationRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i25.AuthRemoteDataSource>(
      () => _i25.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i854.ProgressRemoteDataSource>(
      () => _i854.ProgressRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i913.ExerciseRemoteDataSource>(
      () => _i913.ExerciseRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i909.ThemeCubit>(
      () => _i909.ThemeCubit(themeRepository: gh<_i416.ThemeRepository>()),
    );
    gh.lazySingleton<_i655.LeaderboardRepository>(
      () => _i1008.LeaderboardRepositoryImpl(
        gh<_i386.LeaderboardRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i106.ModerationRepository>(
      () => _i378.ModerationRepositoryImpl(
        gh<_i200.ModerationRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i62.ScoreCardRemoteDataSource>(
      () => _i62.ScoreCardRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i287.DiscoverPlaylistRemoteDataSource>(
      () => _i287.DiscoverPlaylistRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i268.VideoDetailRemoteDataSource>(
      () => _i268.VideoDetailRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i362.HomeRemoteDataSource>(
      () => _i362.HomeRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i828.NotebookRemoteDataSource>(
      () => _i828.NotebookRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1012.ProfileRemoteDataSource>(
      () => _i1012.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(gh<_i1012.ProfileRemoteDataSource>()),
    );
    gh.factory<_i793.BlockedUsersCubit>(
      () => _i793.BlockedUsersCubit(gh<_i106.ModerationRepository>()),
    );
    gh.lazySingleton<_i951.DailyChallengeRemoteDataSource>(
      () => _i951.DailyChallengeRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i291.VideoDetailRepository>(
      () => _i272.VideoDetailRepositoryImpl(
        gh<_i268.VideoDetailRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i991.BadgeRemoteDataSource>(
      () => _i991.BadgeRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i344.ChallengeFriendRemoteDataSource>(
      () => _i344.ChallengeFriendRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i65.BadgeRepository>(
      () => _i345.BadgeRepositoryImpl(gh<_i991.BadgeRemoteDataSource>()),
    );
    gh.lazySingleton<_i970.GetXpLeaderboardUseCase>(
      () => _i970.GetXpLeaderboardUseCase(gh<_i655.LeaderboardRepository>()),
    );
    gh.lazySingleton<_i50.ExerciseRepository>(
      () => _i607.ExerciseRepositoryImpl(gh<_i913.ExerciseRemoteDataSource>()),
    );
    gh.lazySingleton<_i520.SettingsRepository>(
      () => _i668.SettingsRepositoryImpl(gh<_i431.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i25.AuthRemoteDataSource>(),
        gh<_i606.AuthLocalDataSource>(),
        gh<_i723.SocialAuthService>(),
      ),
    );
    gh.lazySingleton<_i697.ScoreCardRepository>(
      () => _i384.ScoreCardRepositoryImpl(gh<_i62.ScoreCardRemoteDataSource>()),
    );
    gh.lazySingleton<_i718.NotebookRepository>(
      () => _i168.NotebookRepositoryImpl(gh<_i828.NotebookRemoteDataSource>()),
    );
    gh.lazySingleton<_i0.HomeRepository>(
      () => _i76.HomeRepositoryImpl(
        remoteDataSource: gh<_i362.HomeRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i785.ProgressRepository>(
      () => _i779.ProgressRepositoryImpl(gh<_i854.ProgressRemoteDataSource>()),
    );
    gh.lazySingleton<_i755.GetNotebookWordsUseCase>(
      () => _i755.GetNotebookWordsUseCase(gh<_i718.NotebookRepository>()),
    );
    gh.lazySingleton<_i872.UpdateWordReviewStatusUseCase>(
      () => _i872.UpdateWordReviewStatusUseCase(gh<_i718.NotebookRepository>()),
    );
    gh.lazySingleton<_i960.LocalizationRepository>(
      () => _i682.LocalizationRepositoryImpl(
        gh<_i729.LocalizationLocalDataSource>(),
      ),
    );
    gh.factory<_i186.UpdateProfileUseCase>(
      () => _i186.UpdateProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.lazySingleton<_i772.PlaylistRepository>(
      () => _i899.PlaylistRepositoryImpl(
        remoteDataSource: gh<_i287.DiscoverPlaylistRemoteDataSource>(),
      ),
    );
    gh.factory<_i493.GetPlaylistDetailUseCase>(
      () => _i493.GetPlaylistDetailUseCase(gh<_i772.PlaylistRepository>()),
    );
    gh.factory<_i880.GetPlaylistsUseCase>(
      () => _i880.GetPlaylistsUseCase(gh<_i772.PlaylistRepository>()),
    );
    gh.factory<_i327.GetDailyPickUseCase>(
      () => _i327.GetDailyPickUseCase(gh<_i0.HomeRepository>()),
    );
    gh.factory<_i1010.GetPersonalizedSlotsUseCase>(
      () => _i1010.GetPersonalizedSlotsUseCase(gh<_i0.HomeRepository>()),
    );
    gh.lazySingleton<_i1011.ChallengeFriendRepository>(
      () => _i594.ChallengeFriendRepositoryImpl(
        gh<_i344.ChallengeFriendRemoteDataSource>(),
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
    gh.lazySingleton<_i134.DailyChallengeRepository>(
      () => _i617.DailyChallengeRepositoryImpl(
        gh<_i951.DailyChallengeRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i738.GetLanguageUseCase>(
      () => _i738.GetLanguageUseCase(gh<_i960.LocalizationRepository>()),
    );
    gh.lazySingleton<_i476.SaveLanguageUseCase>(
      () => _i476.SaveLanguageUseCase(gh<_i960.LocalizationRepository>()),
    );
    gh.factory<_i562.HomeDailyPickBloc>(
      () => _i562.HomeDailyPickBloc(gh<_i327.GetDailyPickUseCase>()),
    );
    gh.lazySingleton<_i467.GetBadgesUseCase>(
      () => _i467.GetBadgesUseCase(gh<_i65.BadgeRepository>()),
    );
    gh.lazySingleton<_i521.SoundSettingsCubit>(
      () => _i521.SoundSettingsCubit(gh<_i520.SettingsRepository>()),
    );
    gh.factory<_i347.XpLeaderboardCubit>(
      () => _i347.XpLeaderboardCubit(gh<_i970.GetXpLeaderboardUseCase>()),
    );
    gh.factory<_i497.GetExerciseUseCase>(
      () => _i497.GetExerciseUseCase(gh<_i50.ExerciseRepository>()),
    );
    gh.factory<_i309.GetVideoTranslationsUseCase>(
      () => _i309.GetVideoTranslationsUseCase(gh<_i50.ExerciseRepository>()),
    );
    gh.factory<_i5.SubmitProgressUseCase>(
      () => _i5.SubmitProgressUseCase(gh<_i50.ExerciseRepository>()),
    );
    gh.factory<_i690.PlaylistDetailCubit>(
      () => _i690.PlaylistDetailCubit(gh<_i493.GetPlaylistDetailUseCase>()),
    );
    gh.factory<_i693.AchievementsCubit>(
      () => _i693.AchievementsCubit(gh<_i467.GetBadgesUseCase>()),
    );
    gh.factory<_i764.HomePersonalizedBloc>(
      () =>
          _i764.HomePersonalizedBloc(gh<_i1010.GetPersonalizedSlotsUseCase>()),
    );
    gh.factory<_i483.VideoDetailCubit>(
      () => _i483.VideoDetailCubit(
        gh<_i714.GetVideoDetailUseCase>(),
        gh<_i203.GetVideoExerciseBlanksUseCase>(),
        gh<_i209.GetLatestVideoProgressUseCase>(),
        gh<_i241.SendVideoReactionUseCase>(),
      ),
    );
    gh.singleton<_i97.LocalizationCubit>(
      () => _i97.LocalizationCubit(
        gh<_i738.GetLanguageUseCase>(),
        gh<_i476.SaveLanguageUseCase>(),
      ),
    );
    gh.factory<_i228.CreateChallengeLinkUseCase>(
      () => _i228.CreateChallengeLinkUseCase(
        gh<_i1011.ChallengeFriendRepository>(),
      ),
    );
    gh.factory<_i71.GetFriendsUseCase>(
      () => _i71.GetFriendsUseCase(gh<_i1011.ChallengeFriendRepository>()),
    );
    gh.lazySingleton<_i748.GetProgressErrorInsightsUseCase>(
      () =>
          _i748.GetProgressErrorInsightsUseCase(gh<_i785.ProgressRepository>()),
    );
    gh.lazySingleton<_i773.GetProgressHistoryUseCase>(
      () => _i773.GetProgressHistoryUseCase(gh<_i785.ProgressRepository>()),
    );
    gh.lazySingleton<_i74.GetProgressSummaryUseCase>(
      () => _i74.GetProgressSummaryUseCase(gh<_i785.ProgressRepository>()),
    );
    gh.factory<_i353.DeleteAccountUseCase>(
      () => _i353.DeleteAccountUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i1013.RegisterUseCase>(
      () => _i1013.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i518.ResendEmailUseCase>(
      () => _i518.ResendEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i774.SetCefrSkippedUseCase>(
      () => _i774.SetCefrSkippedUseCase(gh<_i787.AuthRepository>()),
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
    gh.lazySingleton<_i1058.GetSessionsUseCase>(
      () => _i1058.GetSessionsUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i490.LoginWithGoogleUseCase>(
      () => _i490.LoginWithGoogleUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i169.ResetPasswordUseCase>(
      () => _i169.ResetPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i67.ExerciseCubit>(
      () => _i67.ExerciseCubit(
        gh<_i497.GetExerciseUseCase>(),
        gh<_i309.GetVideoTranslationsUseCase>(),
      ),
    );
    gh.factory<_i575.UpdateProfileCubit>(
      () => _i575.UpdateProfileCubit(gh<_i186.UpdateProfileUseCase>()),
    );
    gh.factory<_i679.ForgotPasswordCubit>(
      () => _i679.ForgotPasswordCubit(gh<_i897.ForgotPasswordUseCase>()),
    );
    gh.factory<_i165.ResetPasswordCubit>(
      () => _i165.ResetPasswordCubit(gh<_i169.ResetPasswordUseCase>()),
    );
    gh.factory<_i987.DiscoverBloc>(
      () => _i987.DiscoverBloc(
        gh<_i552.GetVideosUseCase>(),
        gh<_i821.GetTrendingVideosUseCase>(),
        gh<_i880.GetPlaylistsUseCase>(),
      ),
    );
    gh.factory<_i720.NotebookCubit>(
      () => _i720.NotebookCubit(
        gh<_i755.GetNotebookWordsUseCase>(),
        gh<_i872.UpdateWordReviewStatusUseCase>(),
      ),
    );
    gh.lazySingleton<_i464.AudioFeedbackService>(
      () => _i464.AudioFeedbackServiceImpl(gh<_i521.SoundSettingsCubit>()),
    );
    gh.lazySingleton<_i155.GetDailyChallengeConfigUseCase>(
      () => _i155.GetDailyChallengeConfigUseCase(
        gh<_i134.DailyChallengeRepository>(),
      ),
    );
    gh.lazySingleton<_i1016.GetDailyChallengeLeaderboardUseCase>(
      () => _i1016.GetDailyChallengeLeaderboardUseCase(
        gh<_i134.DailyChallengeRepository>(),
      ),
    );
    gh.lazySingleton<_i935.GetDailyChallengeStreakUseCase>(
      () => _i935.GetDailyChallengeStreakUseCase(
        gh<_i134.DailyChallengeRepository>(),
      ),
    );
    gh.lazySingleton<_i544.SubmitDailyChallengeResultUseCase>(
      () => _i544.SubmitDailyChallengeResultUseCase(
        gh<_i134.DailyChallengeRepository>(),
      ),
    );
    gh.factory<_i498.CefrSelectionCubit>(
      () => _i498.CefrSelectionCubit(
        gh<_i186.UpdateProfileUseCase>(),
        gh<_i774.SetCefrSkippedUseCase>(),
      ),
    );
    gh.factory<_i312.ActiveSessionsCubit>(
      () => _i312.ActiveSessionsCubit(gh<_i1058.GetSessionsUseCase>()),
    );
    gh.lazySingleton<_i481.MainShellCubit>(
      () => _i481.MainShellCubit(
        gh<_i74.GetProgressSummaryUseCase>(),
        gh<_i561.GamificationGlobalCubit>(),
      ),
    );
    gh.factory<_i719.ChallengeFriendCubit>(
      () => _i719.ChallengeFriendCubit(
        gh<_i71.GetFriendsUseCase>(),
        gh<_i228.CreateChallengeLinkUseCase>(),
      ),
    );
    gh.lazySingleton<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i131.SignOutUseCase>(),
        gh<_i477.GetMeUseCase>(),
        gh<_i606.AuthLocalDataSource>(),
        gh<_i446.NotificationService>(),
        gh<_i222.AnalyticsService>(),
        gh<_i352.CrashlyticsService>(),
      ),
    );
    gh.factory<_i749.ProgressCubit>(
      () => _i749.ProgressCubit(
        gh<_i773.GetProgressHistoryUseCase>(),
        gh<_i748.GetProgressErrorInsightsUseCase>(),
      ),
    );
    gh.factory<_i841.DeleteAccountCubit>(
      () => _i841.DeleteAccountCubit(gh<_i353.DeleteAccountUseCase>()),
    );
    gh.factory<_i860.HomeDailyChallengeBloc>(
      () => _i860.HomeDailyChallengeBloc(
        gh<_i155.GetDailyChallengeConfigUseCase>(),
      ),
    );
    gh.factory<_i219.VerifyEmailCubit>(
      () => _i219.VerifyEmailCubit(
        gh<_i421.VerifyEmailUseCase>(),
        gh<_i518.ResendEmailUseCase>(),
        gh<_i1038.LoginUseCase>(),
        gh<_i797.AuthBloc>(),
      ),
    );
    gh.factory<_i838.DailyChallengeBloc>(
      () => _i838.DailyChallengeBloc(
        gh<_i155.GetDailyChallengeConfigUseCase>(),
        gh<_i1016.GetDailyChallengeLeaderboardUseCase>(),
        gh<_i935.GetDailyChallengeStreakUseCase>(),
      ),
    );
    gh.factory<_i292.ResultCubit>(
      () => _i292.ResultCubit(
        gh<_i697.ScoreCardRepository>(),
        gh<_i5.SubmitProgressUseCase>(),
        gh<_i544.SubmitDailyChallengeResultUseCase>(),
      ),
    );
    gh.factory<_i281.LoginCubit>(
      () => _i281.LoginCubit(
        gh<_i1038.LoginUseCase>(),
        gh<_i490.LoginWithGoogleUseCase>(),
        gh<_i723.SocialAuthService>(),
        gh<_i797.AuthBloc>(),
      ),
    );
    gh.factory<_i691.RegisterBloc>(
      () => _i691.RegisterBloc(
        gh<_i1013.RegisterUseCase>(),
        gh<_i490.LoginWithGoogleUseCase>(),
        gh<_i723.SocialAuthService>(),
        gh<_i797.AuthBloc>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i461.AppModule {}

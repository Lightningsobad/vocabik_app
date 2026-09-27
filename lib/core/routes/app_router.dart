import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/main_shell/presentation/screens/main_shell_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/discover/presentation/screens/discover_screen.dart';
import '../../features/discover/presentation/screens/playlist_detail_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/widgets/integration/integration_content_view.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/profile/presentation/screens/cefr_selection_screen.dart';
import '../../features/auth/data/data_sources/auth_local_data_source.dart';
import '../../features/video_detail/presentation/screens/video_detail_screen.dart';
import '../../features/exercise/presentation/screens/exercise_screen.dart';
import '../../features/exercise/presentation/screens/result_screen.dart';
import '../../features/exercise/presentation/models/exercise_result_args.dart';
import '../../features/classroom/presentation/screens/my_classrooms_screen.dart';
import '../../features/classroom/presentation/screens/classroom_detail_screen.dart';
import '../../features/classroom/domain/entities/classroom_entity.dart';
import '../di/injection.dart';
import '../../features/legal/presentation/screens/legal_screen.dart';
import '../../features/pricing/presentation/screens/pricing_screen.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../shared/domain/entities/video_entity.dart';
import '../../shared/domain/enums/exercise_type.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/daily_challenge/presentation/screens/daily_challenge_screen.dart';
import '../../features/daily_challenge/domain/entities/daily_challenge_config_entity.dart';
import '../../features/leaderboard/presentation/screens/xp_leaderboard_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/notebook/presentation/cubit/notebook_cubit.dart';
import '../../features/notebook/presentation/screens/notebook_screen.dart';
import '../../features/challenge_friend/presentation/models/challenge_friend_args.dart';
import '../../features/challenge_friend/presentation/models/challenge_sent_args.dart';
import '../../features/challenge_friend/presentation/screens/challenge_friend_screen.dart';
import '../../features/challenge_friend/presentation/screens/challenge_sent_screen.dart';
import '../services/analytics_service.dart';
import '../services/crashlytics_service.dart';

class CrashlyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final routeName = route.settings.name ?? route.settings.arguments?.toString();
    if (routeName != null && getIt.isRegistered<CrashlyticsService>()) {
      getIt<CrashlyticsService>().log('Navigation: push $routeName');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final prevName = previousRoute?.settings.name ?? previousRoute?.settings.arguments?.toString();
    if (prevName != null && getIt.isRegistered<CrashlyticsService>()) {
      getIt<CrashlyticsService>().log('Navigation: pop back to $prevName');
    }
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  observers: [
    if (getIt.isRegistered<AnalyticsService>())
      getIt<AnalyticsService>().getNavigatorObserver(),
    CrashlyticsRouteObserver(),
  ],
  redirect: (context, state) {
    final localDataSource = getIt<AuthLocalDataSource>();
    final isLoggedIn = localDataSource.getAccessToken() != null;

    // Allowed routes for unauthenticated users
    final unauthAllowedRoutes = [
      '/login',
      '/register',
      '/verify-email',
      '/forgot-password',
      '/reset-password',
      '/terms-of-service',
      '/privacy-policy',
    ];
    final isUnauthAllowed =
        unauthAllowedRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isUnauthAllowed) {
      return '/login';
    }

    if (isLoggedIn) {
      final authBloc = getIt<AuthBloc>();
      final user = authBloc.state.user;

      // 1. Check if email is verified
      if (user != null && !user.emailVerified) {
        if (state.matchedLocation != '/verify-email') {
          return '/verify-email';
        }
        return null;
      }

      // 2. Check if CEFR level is selected or skipped
      final hasSkippedCefr = localDataSource.isCefrSkipped();
      if (!hasSkippedCefr && user != null && user.cefrLevel == null) {
        if (state.matchedLocation != '/cefr-selection') {
          return '/cefr-selection';
        }
        return null;
      }

      if (state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/reset-password') {
        return '/home';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Splash Screen'),
      // Redirect to /home from splash for now to see the navigation bar
      redirect: (context, state) => '/home',
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final token =
            state.uri.queryParameters['token'] ??
            (state.extra as Map<String, dynamic>?)?['token'] as String? ??
            '';
        return ResetPasswordScreen(token: token);
      },
    ),
    GoRoute(
      path: '/terms-of-service',
      builder: (context, state) => const LegalScreen(
        type: LegalScreenType.termsOfService,
        isFullscreen: true,
      ),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const LegalScreen(
        type: LegalScreenType.privacyPolicy,
        isFullscreen: true,
      ),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final token =
            extra['token'] as String? ?? state.uri.queryParameters['token'];
        final email =
            extra['email'] as String? ??
            state.uri.queryParameters['email'] ??
            '';
        final password = extra['password'] as String? ?? '';
        return VerifyEmailScreen(
          email: email,
          password: password,
          token: token,
        );
      },
    ),
    GoRoute(
      path: '/cefr-selection',
      builder: (context, state) => const CefrSelectionScreen(),
    ),
    GoRoute(
      path: '/video/:id',
      redirect: (context, state) {
        final id = state.pathParameters['id']!;
        return '/home/video/$id';
      },
    ),
    GoRoute(
      path: '/exercise/:videoId',
      pageBuilder: (context, state) {
        final videoId = state.pathParameters['videoId']!;
        // Assuming we pass cefr_level and version_id as query params or default them
        final cefrLevel = state.uri.queryParameters['cefr_level'] ?? 'B1';
        final versionId = state.uri.queryParameters['version_id'] ?? 'v1';
        final youtubeVideoId =
            state.uri.queryParameters['youtube_video_id'] ?? '';
        final videoTitle = state.uri.queryParameters['video_title'] ?? '';
        final exerciseType = state.uri.queryParameters['exercise_type'] ?? 'Multiple choice';
        final isDailyChallenge =
            state.uri.queryParameters['is_daily_challenge'] == 'true';
        return CustomTransitionPage(
          key: state.pageKey,
          child: ExerciseScreen(
            videoId: videoId,
            cefrLevel: cefrLevel,
            versionId: versionId,
            youtubeVideoId: youtubeVideoId,
            videoTitle: videoTitle,
            exerciseType: exerciseType,
            isDailyChallenge: isDailyChallenge,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/challenge-friend',
      pageBuilder: (context, state) {
        final args = state.extra as ChallengeFriendArgs;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChallengeFriendScreen(args: args),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/challenge-sent',
      redirect: (context, state) => '/home/challenge-sent',
    ),
    GoRoute(
      path: '/pricing',
      redirect: (context, state) => '/home/pricing',
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Player Screen'),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'terms-of-service',
                  builder: (context, state) => const LegalScreen(
                    type: LegalScreenType.termsOfService,
                    isFullscreen: false,
                  ),
                ),
                GoRoute(
                  path: 'privacy-policy',
                  builder: (context, state) => const LegalScreen(
                    type: LegalScreenType.privacyPolicy,
                    isFullscreen: false,
                  ),
                ),
                GoRoute(
                  path: 'pricing',
                  builder: (context, state) => const PricingScreen(),
                ),
                GoRoute(
                  path: 'video/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return VideoDetailScreen(videoId: id);
                  },
                ),
                GoRoute(
                  path: 'exercise-result',
                  pageBuilder: (context, state) {
                    final args = state.extra as ExerciseResultArgs;
                    return CustomTransitionPage(
                      key: ValueKey('${args.exercise.videoId}_${args.durationMs}_${args.selectedAnswers.hashCode}'),
                      child: ResultScreen(
                        key: ValueKey('${args.exercise.videoId}_${args.durationMs}_${args.selectedAnswers.hashCode}'),
                        exercise: args.exercise,
                        selectedAnswers: args.selectedAnswers,
                        checkResults: args.checkResults,
                        durationMs: args.durationMs,
                        youtubeVideoId: args.youtubeVideoId,
                        videoTitle: args.videoTitle,
                        exerciseType: args.exerciseType,
                        isDailyChallenge: args.isDailyChallenge,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'challenge-friend',
                      redirect: (context, state) => '/challenge-friend',
                    ),
                    GoRoute(
                      path: 'challenge-sent',
                      redirect: (context, state) => '/home/challenge-sent',
                    ),
                  ],
                ),
                GoRoute(
                  path: 'daily-challenge',
                  builder: (context, state) {
                    final config = state.extra as DailyChallengeResponseEntity?;
                    return DailyChallengeScreen(initialConfig: config);
                  },
                ),
                GoRoute(
                  path: 'challenge-friend',
                  redirect: (context, state) => '/challenge-friend',
                ),
                GoRoute(
                  path: 'challenge-sent',
                  pageBuilder: (context, state) {
                    final args = state.extra as ChallengeSentArgs;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: ChallengeSentScreen(args: args),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (context, state) => const DiscoverScreen(),
              routes: [
                GoRoute(
                  path: 'video/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return VideoDetailScreen(videoId: id);
                  },
                ),
                GoRoute(
                  path: 'playlist/:slug',
                  builder: (context, state) {
                    final slug = state.pathParameters['slug']!;
                    return PlaylistDetailScreen(slug: slug);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
              routes: [
                GoRoute(
                  path: 'achievements',
                  builder: (context, state) => const AchievementsScreen(),
                ),
                GoRoute(
                  path: 'leaderboard',
                  builder: (context, state) => const XpLeaderboardScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'achievements',
                  builder: (context, state) => const AchievementsScreen(),
                ),
                GoRoute(
                  path: 'leaderboard',
                  builder: (context, state) => const XpLeaderboardScreen(),
                ),
                GoRoute(
                  path: 'notebook',
                  builder: (context, state) => BlocProvider(
                    create: (context) => getIt<NotebookCubit>()..fetchWords(),
                    child: const NotebookScreen(),
                  ),
                ),
                GoRoute(
                  path: 'integration',
                  builder: (context, state) => const IntegrationContentView(),
                ),
                GoRoute(
                  path: 'daily-challenge',
                  builder: (context, state) {
                    final config = state.extra as DailyChallengeResponseEntity?;
                    return DailyChallengeScreen(initialConfig: config);
                  },
                ),
                GoRoute(
                  path: 'pricing',
                  builder: (context, state) => const PricingScreen(),
                ),
                GoRoute(
                  path: 'classrooms',
                  builder: (context, state) => const MyClassroomsScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        final classroom = state.extra as ClassroomEntity?;
                        return ClassroomDetailScreen(
                          id: id,
                          classroom: classroom,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

extension ExerciseNavigationExtension on BuildContext {
  void pushToExercise({
    required String videoId,
    required String cefrLevel,
    String versionId = 'v1',
    required String youtubeVideoId,
    required String videoTitle,
    ExerciseType exerciseType = ExerciseType.multipleChoice,
    bool isDailyChallenge = false,
  }) {
    final uri = Uri(
      path: '/exercise/$videoId',
      queryParameters: {
        'cefr_level': cefrLevel,
        'version_id': versionId,
        'youtube_video_id': youtubeVideoId,
        'video_title': videoTitle,
        'exercise_type': exerciseType.value,
        'is_daily_challenge': isDailyChallenge.toString(),
      },
    );
    push(uri.toString());
  }

  void pushReplacementToExercise({
    required String videoId,
    required String cefrLevel,
    String versionId = 'v1',
    required String youtubeVideoId,
    required String videoTitle,
    ExerciseType exerciseType = ExerciseType.multipleChoice,
    bool isDailyChallenge = false,
  }) {
    final uri = Uri(
      path: '/exercise/$videoId',
      queryParameters: {
        'cefr_level': cefrLevel,
        'version_id': versionId,
        'youtube_video_id': youtubeVideoId,
        'video_title': videoTitle,
        'exercise_type': exerciseType.value,
        'is_daily_challenge': isDailyChallenge.toString(),
      },
    );
    pushReplacement(uri.toString());
  }

  void pushVideoToExercise({
    required VideoEntity video,
    String? versionId,
    ExerciseType exerciseType = ExerciseType.multipleChoice,
  }) {
    pushToExercise(
      videoId: video.id,
      cefrLevel: video.cefrLevel,
      versionId: versionId ?? video.canonicalVersion ?? 'v1',
      youtubeVideoId: video.youtubeVideoId,
      videoTitle: video.title,
      exerciseType: exerciseType,
    );
  }

  void goToExerciseResult(ExerciseResultArgs args) {
    go('/home/exercise-result', extra: args);
  }

  void pushToChallengeFriend(ChallengeFriendArgs args) {
    push('/challenge-friend', extra: args);
  }

  void pushReplacementToChallengeSent(ChallengeSentArgs args) {
    go('/home/challenge-sent', extra: args);
  }

  void pushToChallengeSent(ChallengeSentArgs args) {
    go('/home/challenge-sent', extra: args);
  }
}


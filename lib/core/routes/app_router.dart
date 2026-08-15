import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/main_shell/presentation/screens/main_shell_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/discover/presentation/screens/discover_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/widgets/integration/integration_content_view.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/profile/presentation/screens/cefr_selection_screen.dart';
import '../../features/auth/data/data_sources/auth_local_data_source.dart';
import '../../features/video_detail/presentation/screens/video_detail_screen.dart';
import '../../features/exercise/presentation/screens/exercise_screen.dart';
import '../di/injection.dart';

// TODO: Thay thế bằng các màn hình thật trong tương lai
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
  redirect: (context, state) {
    final localDataSource = getIt<AuthLocalDataSource>();
    final isLoggedIn = localDataSource.getAccessToken() != null;
    
    // Allowed routes for unauthenticated users
    final unauthRoutes = ['/login', '/register', '/verify-email'];
    final isUnauthRoute = unauthRoutes.contains(state.matchedLocation);
    
    if (!isLoggedIn && !isUnauthRoute) {
      return '/login';
    }
    
    if (isLoggedIn && isUnauthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PlaceholderScreen(title: 'Splash Screen'),
      // Redirect to /home from splash for now to see the navigation bar
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return VerifyEmailScreen(
          email: extra['email'] as String? ?? 'an.nguyen@gmail.com',
          password: extra['password'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/cefr-selection',
      builder: (context, state) => const CefrSelectionScreen(),
    ),
    GoRoute(
      path: '/video/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return VideoDetailScreen(videoId: id);
      },
    ),
    GoRoute(
      path: '/exercise/:videoId',
      builder: (context, state) {
        final videoId = state.pathParameters['videoId']!;
        // Assuming we pass cefr_level and version_id as query params or default them
        final cefrLevel = state.uri.queryParameters['cefr_level'] ?? 'B1';
        final versionId = state.uri.queryParameters['version_id'] ?? 'v1';
        final youtubeVideoId = state.uri.queryParameters['youtube_video_id'] ?? '';
        final videoTitle = state.uri.queryParameters['video_title'] ?? '';
        return ExerciseScreen(
          videoId: videoId,
          cefrLevel: cefrLevel,
          versionId: versionId,
          youtubeVideoId: youtubeVideoId,
          videoTitle: videoTitle,
        );
      },
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) => const PlaceholderScreen(title: 'Player Screen'),
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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (context, state) => const DiscoverScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
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
                  path: 'integration',
                  builder: (context, state) => const IntegrationContentView(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

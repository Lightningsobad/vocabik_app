import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_progress_bar.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_brand_text.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Remove native splash screen as soon as Flutter renders the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        FlutterNativeSplash.remove();
      } catch (_) {
        // Safe fallback in test or unsupported environments
      }
    });

    // 2. Entrance animation for Logo and Brand Text
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _entranceController.forward();

    // 3. Progress bar animation (0% -> 100%)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _handleNavigation();
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _handleNavigation() async {
    // If AuthBloc is currently checking auth, wait briefly for it
    if (getIt.isRegistered<AuthBloc>()) {
      final authBloc = getIt<AuthBloc>();
      if (authBloc.state.status == AuthStatus.loading) {
        try {
          await authBloc.stream
              .firstWhere((state) => state.status != AuthStatus.loading)
              .timeout(const Duration(seconds: 2));
        } catch (_) {
          // Timeout fallback - continue navigation
        }
      }
    }

    if (!mounted) return;

    final localDataSource = getIt<AuthLocalDataSource>();
    final isLoggedIn = localDataSource.getAccessToken() != null;

    if (!isLoggedIn) {
      context.go('/login');
      return;
    }

    final authBloc = getIt<AuthBloc>();
    final user = authBloc.state.user;

    // 1. Verify email check
    if (user != null && !user.emailVerified) {
      context.go('/verify-email');
      return;
    }

    // 2. CEFR level selection check
    final hasSkippedCefr = localDataSource.isCefrSkipped();
    if (!hasSkippedCefr && user != null && user.cefrLevel == null) {
      context.go('/cefr-selection');
      return;
    }

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VocabikLogo(size: 88),
                const SizedBox(height: AppSpacing.md),
                const VocabikBrandText(fontSize: 32),
                const SizedBox(height: AppSpacing.xl3),
                // App Progress Bar styled with brand theme
                SizedBox(
                  width: 140,
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, _) {
                      return AppProgressBar(
                        progress: _progressAnimation.value,
                        height: 4.0,
                        color: colors.primaryAccent,
                        backgroundColor: colors.borderSubtle,
                        animate: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

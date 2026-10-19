import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/legal/presentation/widgets/privacy_policy_content_view.dart';
import 'package:vocabik_app/features/legal/presentation/widgets/terms_of_service_content_view.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

enum LegalScreenType {
  termsOfService,
  privacyPolicy,
}

class LegalScreen extends StatelessWidget {
  final LegalScreenType type;
  final bool isFullscreen;

  const LegalScreen({
    super.key,
    required this.type,
    this.isFullscreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    final contentWidget = type == LegalScreenType.termsOfService
        ? const TermsOfServiceContentView()
        : const PrivacyPolicyContentView();

    if (isFullscreen) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: BounceWrapper(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                final isLoggedIn =
                    getIt<AuthLocalDataSource>().getAccessToken() != null;
                if (!isLoggedIn) {
                  context.go('/login');
                } else {
                  final user = getIt<AuthBloc>().state.user;
                  if (user != null && !user.emailVerified) {
                    context.go('/verify-email');
                  } else if (user != null &&
                      user.cefrLevel == null &&
                      !getIt<AuthLocalDataSource>().isCefrSkipped()) {
                    context.go('/cefr-selection');
                  } else {
                    context.go('/home');
                  }
                }
              }
            },
            child: Icon(
              LucideIcons.arrowLeft,
              color: colors.textPrimary,
              size: AppSpacing.xl,
            ),
          ),
        ),
        body: SafeArea(
          child: contentWidget,
        ),
      );
    }

    // Embedded in MainShellScreen (with AppHeader and CustomBottomNavigationBar)
    return Container(
      color: colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              top: AppSpacing.md,
              bottom: AppSpacing.tn,
            ),
            child: BounceWrapper(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              child: Container(
                width: AppSpacing.xl4,
                height: AppSpacing.xl4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Icon(
                  LucideIcons.arrowLeft,
                  color: colors.textPrimary,
                  size: AppSpacing.lg,
                ),
              ),
            ),
          ),
          Expanded(child: contentWidget),
        ],
      ),
    );
  }
}

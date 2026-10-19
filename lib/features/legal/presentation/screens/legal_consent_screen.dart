import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_card_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class LegalConsentScreen extends StatefulWidget {
  const LegalConsentScreen({super.key});

  @override
  State<LegalConsentScreen> createState() => _LegalConsentScreenState();
}

class _LegalConsentScreenState extends State<LegalConsentScreen> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push('/terms-of-service');
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push('/privacy-policy');
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  Future<void> _agreeAndProceed() async {
    setState(() => _isLoading = true);
    final authBloc = getIt<AuthBloc>();
    final user = authBloc.state.user;
    final localDataSource = getIt<AuthLocalDataSource>();

    await localDataSource.setLegalAccepted(
      AuthLocalDataSource.currentLegalVersion,
      userId: user?.id,
    );

    if (mounted) {
      if (user != null && !user.emailVerified) {
        context.go('/verify-email');
      } else if (user != null &&
          user.cefrLevel == null &&
          !localDataSource.isCefrSkipped()) {
        context.go('/cefr-selection');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: AuthCardWrapper(
            children: [
              const Center(child: VocabikLogo(size: 48)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.legalConsentTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: AppFontSize.xl3,
                  fontWeight: FontWeight.w900,
                  color: colors?.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.legalConsentDescription,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: colors?.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Links to view Terms & Privacy
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors?.surfaceCard ?? const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: colors?.borderSubtle ?? Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    text: '${l10n.termsOfServiceTitle}: ',
                    style: GoogleFonts.nunito(
                      fontSize: AppFontSize.sm,
                      color: colors?.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: l10n.termsText,
                        recognizer: _termsRecognizer,
                        style: TextStyle(
                          color: colors?.primaryAccent,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: '\n${l10n.privacyPolicyTitle}: ',
                        style: GoogleFonts.nunito(
                          fontSize: AppFontSize.sm,
                          color: colors?.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: l10n.securityText,
                        recognizer: _privacyRecognizer,
                        style: TextStyle(
                          color: colors?.primaryAccent,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl2),
              PrimaryButton(
                text: l10n.legalConsentAgreeButton,
                isLoading: _isLoading,
                onPressed: _agreeAndProceed,
              ),
              const SizedBox(height: AppSpacing.md),
              BounceWrapper(
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  context.go('/login');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    l10n.accountLogOut,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: colors?.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

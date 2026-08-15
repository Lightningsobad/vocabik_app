import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/services/deep_link_service.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/verify_email_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/verify_email_state.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;
  final String password;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VerifyEmailCubit>()..startTimer(),
      child: VerifyEmailScreenView(email: email, password: password),
    );
  }
}

class VerifyEmailScreenView extends StatefulWidget {
  final String email;
  final String password;

  const VerifyEmailScreenView({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<VerifyEmailScreenView> createState() => _VerifyEmailScreenViewState();
}

class _VerifyEmailScreenViewState extends State<VerifyEmailScreenView> {
  StreamSubscription<String>? _tokenSubscription;

  @override
  void initState() {
    super.initState();
    _tokenSubscription = getIt<DeepLinkService>().onTokenReceived.listen((token) {
      if (mounted) {
        context.read<VerifyEmailCubit>().verifyWithToken(token, widget.email, widget.password);
      }
    });
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<VerifyEmailCubit, VerifyEmailState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == VerifyEmailStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Verification failed')),
            );
        } else if (state.status == VerifyEmailStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Xác thực thành công. Vui lòng đăng nhập lại!'),
                backgroundColor: Colors.green,
              ),
            );
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: colors?.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl3),
                decoration: BoxDecoration(
                  color: colors?.surfaceCard,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  const Text(
                    '📬',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.checkYourEmail,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors?.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.checkEmailSubtitle(widget.email),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: colors?.primaryAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl3),
                  
                  // Resend Button
                  BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
                    builder: (context, state) {
                      return BounceWrapper(
                        onTap: state.countdown == 0 && state.status != VerifyEmailStatus.loading
                            ? () => context.read<VerifyEmailCubit>().resendEmail(widget.email)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: state.countdown > 0 || state.status == VerifyEmailStatus.loading
                                ? colors?.background
                                : colors?.primaryAccent,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: state.countdown > 0 || state.status == VerifyEmailStatus.loading
                                  ? colors?.borderSubtle ?? Colors.grey.shade300
                                  : Colors.transparent,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: state.status == VerifyEmailStatus.loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  state.countdown > 0
                                      ? l10n.resendIn(state.countdown)
                                      : "Gửi lại email",
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: state.countdown > 0
                                        ? colors?.textPrimary
                                        : (colors?.onPrimaryAccent ?? Colors.white),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),
                  
                  // I have verified Link
                  BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
                    builder: (context, state) {
                      return BounceWrapper(
                        onTap: state.status == VerifyEmailStatus.loading
                            ? null
                            : () => context.read<VerifyEmailCubit>().checkVerificationOnOtherDevice(widget.email, widget.password),
                        child: Text(
                          l10n.iHaveVerified,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: state.status == VerifyEmailStatus.loading
                                ? Colors.grey
                                : colors?.primaryAccent,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl3),

                  // Spam Tip Box
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors?.background,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Text(
                      l10n.spamCheckTip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: colors?.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

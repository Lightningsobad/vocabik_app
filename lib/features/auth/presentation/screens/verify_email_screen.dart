import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/services/deep_link_service.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/verify_email_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/verify_email_state.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_card_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;
  final String password;
  final String? token;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VerifyEmailCubit>()..startTimer(),
      child: VerifyEmailScreenView(
        email: email,
        password: password,
        token: token,
      ),
    );
  }
}

class VerifyEmailScreenView extends StatefulWidget {
  final String email;
  final String password;
  final String? token;

  const VerifyEmailScreenView({
    super.key,
    required this.email,
    required this.password,
    this.token,
  });

  @override
  State<VerifyEmailScreenView> createState() => _VerifyEmailScreenViewState();
}

class _VerifyEmailScreenViewState extends State<VerifyEmailScreenView>
    with SingleTickerProviderStateMixin {
  StreamSubscription<String>? _tokenSubscription;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: -7.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.token != null && widget.token!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<VerifyEmailCubit>().verifyWithToken(
                widget.token!,
                widget.email,
                widget.password,
              );
        }
      });
    }

    _tokenSubscription = getIt<DeepLinkService>().onTokenReceived.listen((token) {
      if (mounted) {
        context.read<VerifyEmailCubit>().verifyWithToken(token, widget.email, widget.password);
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _tokenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      body: BlocListener<VerifyEmailCubit, VerifyEmailState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == VerifyEmailStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? l10n.verifyFailed)),
              );
          } else if (state.status == VerifyEmailStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.verifySuccessRedirect),
                  backgroundColor: Colors.green,
                ),
              );
            context.go('/cefr-selection');
          }
        },
        child: AuthCardWrapper(
          children: [
            // Floating Email Icon
            Center(
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: child,
                  );
                },
                child: SvgPicture.asset(
                  'assets/verify_email_screen/email_icon.svg',
                  width: 56,
                  height: 56,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              l10n.checkYourEmail,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: AppFontSize.xl3,
                fontWeight: FontWeight.w900,
                color: colors?.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Subtitle - "We sent it to:" / "Chúng tôi đã gửi đến:"
            Text(
              l10n.checkEmailSubtitle(widget.email).split('\n').first,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: AppFontSize.sm,
                color: colors?.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),

            // Email Address
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: AppFontSize.lg,
                color: colors?.primaryAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xl2),

            // Resend Button (PrimaryButton with Secondary Variant)
            BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
              builder: (context, state) {
                final isCountingDown = state.countdown > 0;
                final isLoading = state.status == VerifyEmailStatus.loading;

                return PrimaryButton(
                  variant: PrimaryButtonVariant.secondary,
                  isLoading: isLoading,
                  onPressed: (isCountingDown || isLoading)
                      ? null
                      : () => context.read<VerifyEmailCubit>().resendEmail(widget.email),
                  text: isCountingDown
                      ? l10n.resendIn(state.countdown)
                      : l10n.resendEmail,
                );
              },
            ),
            const SizedBox(height: AppSpacing.md2),

            // "I've verified -> continue" Link
            BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
              builder: (context, state) {
                return BounceWrapper(
                  onTap: state.status == VerifyEmailStatus.loading
                      ? null
                      : () => context.read<VerifyEmailCubit>().checkVerificationOnOtherDevice(widget.email, widget.password),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      l10n.iHaveVerified,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w800,
                        color: state.status == VerifyEmailStatus.loading
                            ? colors?.textSecondary.withValues(alpha: 0.5)
                            : colors?.primaryAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Spam Tip Box
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: colors?.infoSoft ?? const Color(0xFF22304F),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/verify_email_screen/lightbulb_icon.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      l10n.spamCheckTip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                        color: colors?.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Actions: Sign out / Delete account
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                BounceWrapper(
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    context.go('/login');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      l10n.accountLogOut,
                      style: GoogleFonts.nunito(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        color: colors?.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Text(
                  '•',
                  style: GoogleFonts.nunito(
                    fontSize: AppFontSize.sm,
                    color: colors?.textSecondary,
                  ),
                ),
                BounceWrapper(
                  onTap: () => DeleteAccountConfirmationDialog.show(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      l10n.accountDeletePermanently,
                      style: GoogleFonts.nunito(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        color: colors?.danger ?? Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Legal footer links
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                BounceWrapper(
                  onTap: () => context.push('/terms-of-service'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      l10n.termsText,
                      style: GoogleFonts.nunito(
                        fontSize: AppFontSize.tnn,
                        fontWeight: FontWeight.w600,
                        color: colors?.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Text(
                  '•',
                  style: GoogleFonts.nunito(
                    fontSize: AppFontSize.tnn,
                    color: colors?.textSecondary,
                  ),
                ),
                BounceWrapper(
                  onTap: () => context.push('/privacy-policy'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      l10n.securityText,
                      style: GoogleFonts.nunito(
                        fontSize: AppFontSize.tnn,
                        fontWeight: FontWeight.w600,
                        color: colors?.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/social_login_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';

import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/email_password_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors?.background ?? Colors.white,
      body: Stack(
        children: [
          // Background Glow Effect
          if (Theme.of(context).brightness == Brightness.dark)
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (colors?.primaryAccent ?? const Color(0xFF00E5CC)).withValues(alpha: 0.2), // Accent glow
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          if (Theme.of(context).brightness == Brightness.dark)
            Positioned(
              top: 100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x228B5CF6), // Purple glow
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          // Main content
          Positioned.fill(
            child: BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == AuthStatus.success) {
                  context.go('/home');
                } else if (state.status == AuthStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ?? l10n.authGenericError,
                      ),
                    ),
                  );
                }
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: colors?.surfaceCard ?? Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: colors?.borderSubtle ?? Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icon / Logo
                        const Center(child: VocabikLogo(size: 48)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loginTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: AppFontSize.xl4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Social Buttons
                        SocialLoginButton(
                          text: l10n.continueWithGoogle,
                          icon: const Text(
                            'G',
                            style: TextStyle(
                              color: Color(0xFF4285F4),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),
                        SocialLoginButton(
                          text: l10n.continueWithFacebook,
                          icon: const Text(
                            'f',
                            style: TextStyle(
                              color: Color(0xFF1877F2),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                l10n.orText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Form
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) =>
                              previous.email != current.email ||
                              previous.password != current.password,
                          builder: (context, state) {
                            final emailError = state.email.displayError != null
                                ? l10n.emailInvalid
                                : null;
                            final passwordError =
                                state.password.displayError != null
                                ? l10n.passwordMinLength
                                : null;

                            return EmailPasswordForm(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              emailError: emailError,
                              passwordError: passwordError,
                              onEmailChanged: (value) => context
                                  .read<AuthBloc>()
                                  .add(EmailChanged(value)),
                              onPasswordChanged: (value) => context
                                  .read<AuthBloc>()
                                  .add(PasswordChanged(value)),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              l10n.forgotPassword,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors?.primaryAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) =>
                              previous.status != current.status,
                          builder: (context, state) {
                            return PrimaryButton(
                              text: l10n.actionLogin,
                              isLoading: state.status == AuthStatus.loading,
                              onPressed: () => context.read<AuthBloc>().add(
                                const LoginSubmitted(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.noAccount,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () => context.go('/register'),
                              child: Text(
                                l10n.signUpFreeAction,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors?.primaryAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

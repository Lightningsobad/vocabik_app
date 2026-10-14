import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_event.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/register_state.dart';
import 'package:vocabik_app/features/auth/presentation/utils/auth_validation_helper.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_card_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_divider.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/social_login_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterBloc>(),
      child: const RegisterScreenView(),
    );
  }
}

class RegisterScreenView extends StatefulWidget {
  const RegisterScreenView({super.key});

  @override
  State<RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<RegisterScreenView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<RegisterBloc>().add(const RegisterSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listenWhen: (previous, current) =>
            previous.status != current.status,
        listener: (context, state) {
          if (state.status == RegisterStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? l10n.authGenericError,
                  ),
                ),
              );
          } else if (state.status == RegisterStatus.success) {
            context.push('/verify-email', extra: {
              'email': state.email.value,
              'password': state.password.value,
            });
          } else if (state.status == RegisterStatus.socialSuccess) {
            context.go('/home');
          }
        },
        child: AuthCardWrapper(
          children: [
            // Logo
            const Center(child: VocabikLogo(size: 48)),
            const SizedBox(height: 12),

            // Titles
            Text(
              l10n.createFreeAccount,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: AppFontSize.xl4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.startLearningToday,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: colors?.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Social Sign Up
            SocialLoginButton(
              text: l10n.signUpWithGoogle,
              icon: SvgPicture.asset(
                'assets/auth_screen/google-icon-logo-svgrepo-com.svg',
                width: 20,
                height: 20,
              ),
              onPressed: () => context
                  .read<RegisterBloc>()
                  .add(const RegisterWithGoogleSubmitted()),
            ),
            const SizedBox(height: 18),

            // Divider
            const AuthDivider(),
            const SizedBox(height: 18),

            // Form
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
                  previous.displayName != current.displayName ||
                  previous.email != current.email ||
                  previous.password != current.password,
              builder: (context, state) {
                return AuthForm(
                  showNameField: true,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nameError: AuthValidationHelper.getDisplayNameError(
                    context,
                    state.displayName,
                  ),
                  emailError: AuthValidationHelper.getEmailError(
                    context,
                    state.email,
                  ),
                  passwordError: AuthValidationHelper.getPasswordError(
                    context,
                    state.password,
                  ),
                  onNameChanged: (value) => context
                      .read<RegisterBloc>()
                      .add(RegisterDisplayNameChanged(value)),
                  onEmailChanged: (value) => context
                      .read<RegisterBloc>()
                      .add(RegisterEmailChanged(value)),
                  onPasswordChanged: (value) => context
                      .read<RegisterBloc>()
                      .add(RegisterPasswordChanged(value)),
                  onSubmitted: _submit,
                );
              },
            ),
            const SizedBox(height: 10),

            // Password Strength Indicator
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
                  previous.passwordStrength != current.passwordStrength,
              builder: (context, state) {
                return PasswordStrengthIndicator(
                  strength: state.passwordStrength,
                );
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return PrimaryButton(
                  text: l10n.actionSignUp,
                  isLoading: state.status == RegisterStatus.loading,
                  onPressed: _submit,
                );
              },
            ),
            const SizedBox(height: 16),

            // Terms & Security Notice
            Text.rich(
              TextSpan(
                text: l10n.signUpTermsPrefix,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: colors?.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: l10n.termsText,
                    recognizer: _termsRecognizer,
                    style: TextStyle(
                      color: colors?.primaryAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: l10n.signUpTermsAnd,
                    style: TextStyle(color: colors?.textSecondary),
                  ),
                  TextSpan(
                    text: l10n.securityText,
                    recognizer: _privacyRecognizer,
                    style: TextStyle(
                      color: colors?.primaryAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Already have an account? Log in ->
            AuthFooterLink(
              promptText: l10n.alreadyHaveAccountPrompt,
              actionText: l10n.loginActionLink,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

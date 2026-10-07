import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/login_state.dart';
import 'package:vocabik_app/features/auth/presentation/utils/auth_validation_helper.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_card_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_divider.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/social_login_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/vocabik_logo.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
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

  void _submit() {
    context.read<LoginCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            context.go('/home');
          } else if (state.status == LoginStatus.unverified) {
            context.push(
              '/verify-email',
              extra: {
                'email': _emailController.text.trim(),
                'password': _passwordController.text,
              },
            );
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? l10n.authGenericError),
              ),
            );
          }
        },
        child: AuthCardWrapper(
          children: [
            // Icon / Logo
            const Center(child: VocabikLogo(size: 48)),
            const SizedBox(height: 12),
            Text(
              l10n.loginTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: AppFontSize.xl4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            // Social Buttons
            SocialLoginButton(
              text: l10n.continueWithGoogle,
              icon: const Text(
                'G',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
            ),
            const SizedBox(height: 18),
            const AuthDivider(),
            const SizedBox(height: 18),
            // Form
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  previous.email != current.email ||
                  previous.password != current.password,
              builder: (context, state) {
                return AuthForm(
                  showNameField: false,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  emailError: AuthValidationHelper.getEmailError(
                    context,
                    state.email,
                  ),
                  passwordError: AuthValidationHelper.getPasswordError(
                    context,
                    state.password,
                  ),
                  onEmailChanged: (value) =>
                      context.read<LoginCubit>().emailChanged(value),
                  onPasswordChanged: (value) =>
                      context.read<LoginCubit>().passwordChanged(value),
                  onSubmitted: _submit,
                );
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: BounceWrapper(
                onTap: () => context.push('/forgot-password'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    l10n.forgotPassword,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      color: colors?.primaryAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return PrimaryButton(
                  text: l10n.actionLogin,
                  isLoading: state.status == LoginStatus.loading,
                  onPressed: _submit,
                );
              },
            ),
            const SizedBox(height: 16),
            AuthFooterLink(
              promptText: l10n.noAccount,
              actionText: l10n.signUpFreeAction,
              onTap: () => context.go('/register'),
            ),
          ],
        ),
      ),
    );
  }
}

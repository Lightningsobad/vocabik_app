import 'package:vocabik_app/shared/presentation/widgets/notifications/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/forgot_password_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/forgot_password_state.dart';
import 'package:vocabik_app/features/auth/presentation/utils/auth_validation_helper.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_card_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<ForgotPasswordCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            AppSnackBar.showSuccess(
              context,
              state.successMessage ?? l10n.emailSentSuccess,
            );
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          } else if (state.status == ForgotPasswordStatus.failure) {
            AppSnackBar.showError(
              context,
              state.errorMessage ?? l10n.authGenericError,
            );
          }
        },
        child: AuthCardWrapper(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back to login button
            BounceWrapper(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/login');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.backToLogin,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Heading
            Text(
              l10n.forgotPasswordHeading,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl4,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Subtitle
            Text(
              l10n.forgotPasswordSubtitle,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Email input
            BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
              buildWhen: (previous, current) => previous.email != current.email,
              builder: (context, state) {
                return AppTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorText: AuthValidationHelper.getEmailError(
                    context,
                    state.email,
                  ),
                  onChanged: (value) =>
                      context.read<ForgotPasswordCubit>().emailChanged(value),
                  onSubmitted: (_) => _submit(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Submit button
            BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return PrimaryButton(
                  text: l10n.sendResetLink,
                  isLoading: state.status == ForgotPasswordStatus.loading,
                  onPressed: _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

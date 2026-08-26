import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/reset_password_cubit.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/reset_password_state.dart';
import 'package:vocabik_app/features/auth/presentation/utils/auth_validation_helper.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/auth/auth_card_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/password_input_widget.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: ResetPasswordView(token: token),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  final String token;

  const ResetPasswordView({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<ResetPasswordCubit>().submit(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ResetPasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.successMessage ?? l10n.resetPasswordSuccess,
                ),
              ),
            );
            context.go('/login');
          } else if (state.status == ResetPasswordStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? l10n.authGenericError,
                ),
              ),
            );
          }
        },
        child: AuthCardWrapper(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              l10n.resetPasswordHeading,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl4,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // New password field
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              buildWhen: (previous, current) =>
                  previous.newPassword != current.newPassword,
              builder: (context, state) {
                return PasswordInputWidget(
                  controller: _newPasswordController,
                  hintText: l10n.newPasswordHint,
                  textInputAction: TextInputAction.next,
                  errorText: AuthValidationHelper.getPasswordError(
                    context,
                    state.newPassword,
                  ),
                  onChanged: (value) => context
                      .read<ResetPasswordCubit>()
                      .newPasswordChanged(value),
                  onFieldSubmitted: (_) =>
                      _confirmPasswordFocusNode.requestFocus(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Confirm password field
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              buildWhen: (previous, current) =>
                  previous.confirmPassword != current.confirmPassword ||
                  previous.isPasswordMatch != current.isPasswordMatch,
              builder: (context, state) {
                return PasswordInputWidget(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  hintText: l10n.confirmPasswordHint,
                  textInputAction: TextInputAction.done,
                  errorText: !state.isPasswordMatch
                      ? l10n.passwordsDoNotMatch
                      : null,
                  onChanged: (value) => context
                      .read<ResetPasswordCubit>()
                      .confirmPasswordChanged(value),
                  onFieldSubmitted: (_) => _submit(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Submit button
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return PrimaryButton(
                  text: l10n.resetPasswordAction,
                  isLoading: state.status == ResetPasswordStatus.loading,
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

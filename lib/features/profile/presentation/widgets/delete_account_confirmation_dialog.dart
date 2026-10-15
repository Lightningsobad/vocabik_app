import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/delete_account_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/password_input_widget.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DeleteAccountConfirmationDialog extends StatefulWidget {
  const DeleteAccountConfirmationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const DeleteAccountConfirmationDialog(),
    );
  }

  @override
  State<DeleteAccountConfirmationDialog> createState() =>
      _DeleteAccountConfirmationDialogState();
}

class _DeleteAccountConfirmationDialogState
    extends State<DeleteAccountConfirmationDialog> {
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? _resolveErrorMessage(
    BuildContext context,
    DeleteAccountState state,
    AppLocalizations l10n,
  ) {
    if (state.status != DeleteAccountStatus.failure) return null;
    if (state.failure is PasswordRequiredFailure) {
      return l10n.deleteAccountErrorPasswordRequired;
    }
    if (state.failure is InvalidPasswordFailure) {
      return l10n.deleteAccountErrorInvalidPassword;
    }
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      return state.errorMessage;
    }
    return l10n.deleteAccountErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<DeleteAccountCubit>(),
      child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) {
          if (state.status == DeleteAccountStatus.success) {
            Navigator.of(context).pop();
            context.read<AuthBloc>().add(const SessionExpired());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.deleteAccountSuccessMessage,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: colors.success,
              ),
            );
          } else if (state.status == DeleteAccountStatus.failure) {
            if (state.failure is PasswordRequiredFailure ||
                state.failure is InvalidPasswordFailure) {
              _passwordFocusNode.requestFocus();
            }
          }
        },
        builder: (context, state) {
          final isLoading = state.status == DeleteAccountStatus.loading;
          final errorMessage = _resolveErrorMessage(context, state, l10n);

          return AlertDialog(
            backgroundColor: colors.surfaceCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            title: Text(
              l10n.deleteAccountDialogTitle,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.deleteAccountDialogWarning,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.deleteAccountPasswordLabel,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.tn),
                  Text(
                    l10n.deleteAccountPasswordOptionalNote,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.tnn,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PasswordInputWidget(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    hintText: l10n.deleteAccountPasswordHint,
                    errorText: errorMessage,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: isLoading
                        ? null
                        : (_) {
                            context.read<DeleteAccountCubit>().deleteAccount(
                                  password: _passwordController.text.trim(),
                                );
                          },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: Text(
                  l10n.actionCancel,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<DeleteAccountCubit>().deleteAccount(
                              password: _passwordController.text.trim(),
                            );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.danger,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: colors.danger.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: AppSpacing.lg,
                        height: AppSpacing.lg,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.deleteAccountConfirmAction,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

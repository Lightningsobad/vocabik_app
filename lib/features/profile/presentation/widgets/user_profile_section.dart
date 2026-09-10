import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/domain/entities/user.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/update_profile_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/update_profile_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (_) => getIt<UpdateProfileCubit>(),
      child: const _UserProfileSectionContent(),
    );
  }
}

class _UserProfileSectionContent extends StatefulWidget {
  const _UserProfileSectionContent();

  @override
  State<_UserProfileSectionContent> createState() =>
      _UserProfileSectionContentState();
}

class _UserProfileSectionContentState
    extends State<_UserProfileSectionContent> {
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  bool _isEditing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameFocusNode = FocusNode();
    // Dispatch request to fetch user info from GET /auth/me
    context.read<AuthBloc>().add(const GetMeRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    if (_isEditing) return;
    setState(() {
      _isEditing = true;
      _errorMessage = null;
    });
    _nameFocusNode.requestFocus();
    _nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nameController.text.length),
    );
  }

  void _cancelEditing(String currentDisplayName) {
    setState(() {
      _isEditing = false;
      _errorMessage = null;
      _nameController.text = currentDisplayName;
    });
    _nameFocusNode.unfocus();
  }

  void _saveDisplayName(User currentUser) {
    final trimmedName = _nameController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (trimmedName.isEmpty) {
      setState(() {
        _errorMessage = l10n.nameCannotBeEmpty;
      });
      return;
    }

    if (trimmedName == currentUser.displayName) {
      _cancelEditing(currentUser.displayName);
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    context.read<UpdateProfileCubit>().updateProfile(
      displayName: trimmedName,
      cefrLevel: currentUser.cefrLevel ?? 'A1',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, updateState) {
        if (updateState.status == UpdateProfileStatus.failure) {
          setState(() {
            _errorMessage = updateState.errorMessage;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                updateState.errorMessage ?? l10n.profileLoadError,
                style: AppTextStyles.custom(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: colors.danger,
            ),
          );
        } else if (updateState.status == UpdateProfileStatus.success) {
          final authState = context.read<AuthBloc>().state;
          final currentUser = authState.user;
          if (currentUser != null) {
            final newDisplayName =
                updateState.updatedProfile?.displayName ??
                _nameController.text.trim();
            final newCefr =
                updateState.updatedProfile?.cefrLevel ?? currentUser.cefrLevel;
            final updatedUser = currentUser.copyWith(
              displayName: newDisplayName,
              cefrLevel: newCefr,
            );
            context.read<AuthBloc>().add(UserProfileUpdated(updatedUser));
          }

          setState(() {
            _isEditing = false;
            _errorMessage = null;
            if (updateState.updatedProfile?.displayName != null) {
              _nameController.text = updateState.updatedProfile!.displayName!;
            }
          });
          _nameFocusNode.unfocus();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.profileUpdateSuccess,
                style: AppTextStyles.custom(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: colors.success,
            ),
          );
        }
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (!_isEditing &&
              state.user != null &&
              _nameController.text != state.user!.displayName) {
            _nameController.text = state.user!.displayName;
          }
        },
        builder: (context, authState) {
          final isLoading =
              authState.status == AuthStatus.loading && authState.user == null;
          final isFailure =
              authState.status == AuthStatus.failure && authState.user == null;

          if (isLoading) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
              child: Center(
                child: CircularProgressIndicator(color: colors.textPrimary),
              ),
            );
          }

          if (isFailure) {
            return _ProfileErrorView(
              errorMessage: authState.errorMessage ?? l10n.profileLoadError,
              onRetry: () =>
                  context.read<AuthBloc>().add(const GetMeRequested()),
            );
          }

          final user = authState.user;
          final displayName = user?.displayName ?? l10n.profileDefaultUser;
          final email = user?.email ?? '';

          if (!_isEditing && _nameController.text != displayName) {
            _nameController.text = displayName;
          }

          return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
            builder: (context, updateState) {
              final isSubmitting =
                  updateState.status == UpdateProfileStatus.loading;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileAvatarSection(displayName: displayName),
                    const SizedBox(height: 24.0),
                    _EditableNameField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      isEditing: _isEditing,
                      isSubmitting: isSubmitting,
                      errorMessage: _errorMessage,
                      onStartEditing: user != null && !isSubmitting
                          ? _startEditing
                          : null,
                      onCancelEditing: () => _cancelEditing(displayName),
                      onSave: user != null && !isSubmitting
                          ? () => _saveDisplayName(user)
                          : null,
                      onChanged: (_) {
                        if (_errorMessage != null) {
                          setState(() => _errorMessage = null);
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _ReadonlyInfoSection(
                      email: email,
                      createdAt: user?.createdAt,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ProfileErrorView({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: [
          Text(
            errorMessage,
            style: AppTextStyles.custom(
              color: colors.textSecondary,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          BounceWrapper(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Text(
                l10n.profileRetry,
                style: AppTextStyles.custom(
                  fontSize: 14.0,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatarSection extends StatelessWidget {
  final String displayName;

  const _ProfileAvatarSection({required this.displayName});

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final initials = _getInitials(displayName);

    return Row(
      children: [
        Container(
          width: 64.0,
          height: 64.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceCard,
            border: Border.all(color: colors.borderSubtle, width: 1.0),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: AppTextStyles.custom(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 22.0,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        BounceWrapper(
          onTap: () {
            // TODO: Change photo logic
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 48.0),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: colors.borderSubtle, width: 1.0),
              color: colors.surfaceCard,
            ),
            child: Text(
              l10n.profileChangePhoto,
              style: AppTextStyles.custom(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditableNameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEditing;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback? onStartEditing;
  final VoidCallback onCancelEditing;
  final VoidCallback? onSave;
  final ValueChanged<String>? onChanged;

  const _EditableNameField({
    required this.controller,
    required this.focusNode,
    required this.isEditing,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onStartEditing,
    required this.onCancelEditing,
    required this.onSave,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileYourName,
          style: AppTextStyles.custom(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: AppFontSize.mdt,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: !isEditing && !isSubmitting ? onStartEditing : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: colors.displayNameInputBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: errorMessage != null
                    ? colors.danger
                    : (isEditing
                          ? colors.primaryAccent
                          : colors.displayNameInputBorder),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    readOnly: !isEditing || isSubmitting,
                    onTap: !isEditing && !isSubmitting ? onStartEditing : null,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (!isSubmitting) {
                        onSave?.call();
                      }
                    },
                    onChanged: onChanged,
                    style: AppTextStyles.custom(
                      color: colors.displayNameInputText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (isEditing) ...[
                  if (isSubmitting)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: colors.primaryAccent,
                        ),
                      ),
                    )
                  else ...[
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.textSecondary,
                        size: 20.0,
                      ),
                      tooltip: l10n.actionCancel,
                      splashRadius: 20.0,
                      onPressed: onCancelEditing,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.check_rounded,
                        color: colors.primaryAccent,
                        size: 22.0,
                      ),
                      tooltip: l10n.actionSave,
                      splashRadius: 20.0,
                      onPressed: onSave,
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 6.0),
          Text(
            errorMessage!,
            style: AppTextStyles.custom(
              color: colors.danger,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReadonlyInfoSection extends StatelessWidget {
  final String email;
  final DateTime? createdAt;

  const _ReadonlyInfoSection({required this.email, required this.createdAt});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final memberSinceFormatted = _formatDate(createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Section
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.profileEmail,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.mdt,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: email,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.mdt,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: l10n.profileReadOnly,
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.md,
                ),
              ),
            ],
          ),
          style: AppTextStyles.custom(fontSize: AppFontSize.md),
        ),
        const SizedBox(height: AppSpacing.lg2),

        // Member Since
        Text(
          l10n.profileMemberSince(memberSinceFormatted),
          style: AppTextStyles.custom(
            color: colors.textSecondary,
            fontSize: AppFontSize.lg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

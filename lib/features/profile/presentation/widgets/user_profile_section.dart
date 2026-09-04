import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/domain/entities/user.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class UserProfileSection extends StatefulWidget {
  const UserProfileSection({super.key});

  @override
  State<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  bool _isEditing = false;
  bool _isSubmitting = false;
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
    setState(() {
      _isEditing = true;
      _errorMessage = null;
    });
    _nameFocusNode.requestFocus();
  }

  void _cancelEditing(String currentDisplayName) {
    setState(() {
      _isEditing = false;
      _errorMessage = null;
      _nameController.text = currentDisplayName;
    });
    _nameFocusNode.unfocus();
  }

  Future<void> _saveDisplayName(User currentUser) async {
    final trimmedName = _nameController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

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
      _isSubmitting = true;
      _errorMessage = null;
    });

    final updateProfileUseCase = getIt<UpdateProfileUseCase>();
    final result = await updateProfileUseCase(
      displayName: trimmedName,
      cefrLevel: currentUser.cefrLevel ?? 'A1',
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = failure.message;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: colors.danger,
          ),
        );
      },
      (response) {
        final newDisplayName = response.displayName ?? trimmedName;
        final newCefr = response.cefrLevel ?? currentUser.cefrLevel;

        final updatedUser = currentUser.copyWith(
          displayName: newDisplayName,
          cefrLevel: newCefr,
        );
        context.read<AuthBloc>().add(UserAuthenticated(updatedUser));

        setState(() {
          _isSubmitting = false;
          _isEditing = false;
          _errorMessage = null;
          _nameController.text = newDisplayName;
        });
        _nameFocusNode.unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdateSuccess),
            backgroundColor: colors.success,
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '15/05/2026';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!_isEditing && state.user != null && _nameController.text != state.user!.displayName) {
          _nameController.text = state.user!.displayName;
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading && state.user == null;
        final isFailure = state.status == AuthStatus.failure && state.user == null;

        if (isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Center(
              child: CircularProgressIndicator(
                color: colors.textPrimary,
              ),
            ),
          );
        }

        if (isFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                Text(
                  state.errorMessage ?? 'Không thể tải thông tin hồ sơ.',
                  style: GoogleFonts.nunito(
                    color: colors.textSecondary,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                BounceWrapper(
                  onTap: () {
                    context.read<AuthBloc>().add(const GetMeRequested());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Text(
                      'Thử lại',
                      style: GoogleFonts.nunito(
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

        final user = state.user;
        final displayName = user?.displayName ?? 'Người dùng';
        final email = user?.email ?? '';
        final initials = _getInitials(displayName);
        final memberSinceFormatted = _formatDate(user?.createdAt);

        if (!_isEditing && _nameController.text != displayName) {
          _nameController.text = displayName;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Change Photo
              Row(
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
                      style: GoogleFonts.nunito(
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
                        style: GoogleFonts.nunito(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Name Field Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.profileYourName,
                    style: GoogleFonts.nunito(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  if (!_isEditing && user != null)
                    BounceWrapper(
                      onTap: _startEditing,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 15.0,
                              color: colors.primaryAccent,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              l10n.actionEdit,
                              style: GoogleFonts.nunito(
                                color: colors.primaryAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: _errorMessage != null
                        ? colors.danger
                        : (_isEditing ? colors.primaryAccent : colors.borderSubtle),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        readOnly: !_isEditing || _isSubmitting,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (user != null && !_isSubmitting) {
                            _saveDisplayName(user);
                          }
                        },
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                        style: GoogleFonts.nunito(
                          color: colors.textPrimary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_isEditing && user != null) ...[
                      if (_isSubmitting)
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
                          icon: Icon(Icons.close_rounded, color: colors.textSecondary, size: 20.0),
                          tooltip: l10n.actionCancel,
                          splashRadius: 20.0,
                          onPressed: () => _cancelEditing(displayName),
                        ),
                        IconButton(
                          icon: Icon(Icons.check_rounded, color: colors.primaryAccent, size: 22.0),
                          tooltip: l10n.actionSave,
                          splashRadius: 20.0,
                          onPressed: () => _saveDisplayName(user),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 6.0),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.nunito(
                    color: colors.danger,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 20.0),

              // Email Section
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: l10n.profileEmail,
                      style: GoogleFonts.nunito(color: colors.textSecondary),
                    ),
                    TextSpan(
                      text: email,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: l10n.profileReadOnly,
                      style: GoogleFonts.nunito(color: colors.textSecondary, fontSize: 13.0),
                    ),
                  ],
                ),
                style: GoogleFonts.nunito(fontSize: 15.0),
              ),
              const SizedBox(height: 12.0),

              // Member Since
              Text(
                l10n.profileMemberSince(memberSinceFormatted),
                style: GoogleFonts.nunito(
                  color: colors.textSecondary,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

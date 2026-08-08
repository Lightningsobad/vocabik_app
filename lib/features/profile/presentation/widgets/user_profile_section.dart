import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    // Dispatch request to fetch user info from GET /auth/me
    context.read<AuthBloc>().add(const GetMeRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        if (state.user != null && _nameController.text != state.user!.displayName) {
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

        if (_nameController.text != displayName) {
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

              // Name Field (Read Only)
              Text(
                l10n.profileYourName,
                style: GoogleFonts.nunito(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: colors.borderSubtle,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  readOnly: true,
                  style: GoogleFonts.nunito(
                    color: colors.textPrimary,
                    fontSize: 16.0,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
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

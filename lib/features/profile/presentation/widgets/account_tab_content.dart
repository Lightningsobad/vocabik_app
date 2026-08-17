import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/utils/dialog_utils.dart';

class AccountTabContent extends StatelessWidget {
  const AccountTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.loading) {
          DialogUtils.showLoading(context);
        } else {
          DialogUtils.hideLoading(context);
          if (state.status == AuthStatus.unauthenticated) {
            context.go('/login');
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? l10n.logoutConfirmTitle)), // Or something generic
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountActionItem(
              title: l10n.accountExportData,
              hasArrow: true,
              onTap: () {
                // TODO: Implement export data
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AccountActionItem(
              title: l10n.accountLogOut,
              hasArrow: false,
              onTap: () => showDialog(
                context: context,
                builder: (_) => const LogoutConfirmationDialog(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DangerActionItem(
              title: l10n.accountDeletePermanently,
              onTap: () {
                // TODO: Implement delete account permanently
              },
            ),
          ],
        ),
      ),
    );
  }

}

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return AlertDialog(
      backgroundColor: colors.surfaceCard,
      title: Text(
        l10n.logoutConfirmTitle,
        style: GoogleFonts.nunito(
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        l10n.logoutConfirmMessage,
        style: GoogleFonts.nunito(
          color: colors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.actionCancel,
            style: GoogleFonts.nunito(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<AuthBloc>().add(LogoutRequested());
          },
          child: Text(
            l10n.actionConfirm,
            style: GoogleFonts.nunito(
              color: colors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class AccountActionItem extends StatelessWidget {
  final String title;
  final bool hasArrow;
  final VoidCallback onTap;

  const AccountActionItem({
    super.key,
    required this.title,
    this.hasArrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BounceWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(
                color: colors.textPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasArrow)
              Icon(
                Icons.arrow_forward_rounded,
                color: colors.textPrimary,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}

class DangerActionItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DangerActionItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BounceWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.dangerSoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: colors.danger.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.nunito(
            color: colors.danger,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

import 'package:vocabik_app/shared/presentation/widgets/notifications/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/blocked_user_entity.dart';
import '../cubit/blocked_users_cubit.dart';
import '../cubit/blocked_users_state.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BlockedUsersCubit>()..loadBlockedUsers(),
      child: const _BlockedUsersView(),
    );
  }
}

class _BlockedUsersView extends StatelessWidget {
  const _BlockedUsersView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BounceWrapper(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
          child: Icon(
            LucideIcons.arrowLeft,
            color: colors.textPrimary,
            size: AppSpacing.xl,
          ),
        ),
        title: Text(
          l10n.blockedUsersTitle,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.xl,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<BlockedUsersCubit, BlockedUsersState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.users.isNotEmpty) {
            AppSnackBar.showError(
              context,
              state.errorMessage!,
            );
          }
        },
        builder: (context, state) {
          if (state.status == BlockedUsersStatus.loading && state.users.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primaryAccent,
              ),
            );
          }

          if (state.status == BlockedUsersStatus.failure && state.users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.alertCircle,
                      size: AppSpacing.xl5,
                      color: colors.danger,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.errorMessage ?? l10n.blockedUsersError,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md,
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<BlockedUsersCubit>().loadBlockedUsers(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryAccent,
                        foregroundColor: colors.onPrimaryAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                      child: Text(l10n.homeRetry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSpacing.xl8,
                      height: AppSpacing.xl8,
                      decoration: BoxDecoration(
                        color: colors.surfaceCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Icon(
                        LucideIcons.shieldCheck,
                        size: AppSpacing.xl4,
                        color: colors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.blockedUsersEmpty,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<BlockedUsersCubit>().loadBlockedUsers(),
            color: colors.primaryAccent,
            backgroundColor: colors.surfaceCard,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              itemCount: state.users.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.sm2),
              itemBuilder: (context, index) {
                final user = state.users[index];
                final isActionLoading =
                    state.actionLoadingUserId == user.userId;
                return _BlockedUserTile(
                  user: user,
                  isActionLoading: isActionLoading,
                  onUnblockTap: () =>
                      _showUnblockConfirmation(context, user, colors, l10n),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showUnblockConfirmation(
    BuildContext context,
    BlockedUserEntity user,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.unblockConfirmTitle,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.xl,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          l10n.unblockConfirmMessage(user.displayName),
          style: AppTextStyles.custom(
            fontSize: AppFontSize.md,
            color: colors.textSecondary,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
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
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final cubit = context.read<BlockedUsersCubit>();
              final success = await cubit.unblockUser(user.userId);
              if (success && context.mounted) {
                AppSnackBar.showSuccess(
                  context,
                  l10n.unblockSuccess(user.displayName),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryAccent,
              foregroundColor: colors.onPrimaryAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: Text(
              l10n.unblockAction,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.bold,
                color: colors.onPrimaryAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedUserTile extends StatelessWidget {
  final BlockedUserEntity user;
  final bool isActionLoading;
  final VoidCallback onUnblockTap;

  const _BlockedUserTile({
    required this.user,
    required this.isActionLoading,
    required this.onUnblockTap,
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final str = parts[0];
      return str.length >= 2 ? str.substring(0, 2).toUpperCase() : str.toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    String dateFormatted = '';
    if (user.blockedAt != null) {
      final d = user.blockedAt!;
      dateFormatted = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        children: [
          // User Avatar / Initials
          Container(
            width: AppSpacing.xl4,
            height: AppSpacing.xl4,
            decoration: BoxDecoration(
              color: colors.optionCardBackground,
              shape: BoxShape.circle,
              border: Border.all(color: colors.optionCardBorder),
            ),
            alignment: Alignment.center,
            child: Text(
              _getInitials(user.displayName),
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // User Name & Blocked date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.displayName,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (dateFormatted.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.blockedAtDate(dateFormatted),
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.tn,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Unblock Button
          OutlinedButton(
            onPressed: isActionLoading ? null : onUnblockTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colors.primaryAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.tnn,
              ),
            ),
            child: isActionLoading
                ? SizedBox(
                    width: AppSpacing.md,
                    height: AppSpacing.md,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: colors.primaryAccent,
                    ),
                  )
                : Text(
                    l10n.unblockAction,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryAccent,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

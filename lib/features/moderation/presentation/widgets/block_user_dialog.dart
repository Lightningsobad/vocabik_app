import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/auth_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/repositories/moderation_repository.dart';

class BlockUserDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final VoidCallback? onUserBlocked;

  const BlockUserDialog({
    super.key,
    required this.userId,
    required this.userName,
    this.onUserBlocked,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String userId,
    required String userName,
    VoidCallback? onUserBlocked,
  }) {
    if (AuthUtils.isCurrentSelf(
      userId: userId,
      userName: userName,
      context: context,
    )) {
      return Future.value(false);
    }

    return showDialog<bool>(
      context: context,
      builder: (_) => BlockUserDialog(
        userId: userId,
        userName: userName,
        onUserBlocked: onUserBlocked,
      ),
    );
  }

  @override
  State<BlockUserDialog> createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends State<BlockUserDialog> {
  bool _isLoading = false;

  Future<void> _handleBlock(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final repo = getIt<ModerationRepository>();
    final result = await repo.blockUser(widget.userId);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              failure.message,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: colors.textPrimary,
              ),
            ),
            backgroundColor: colors.danger,
          ),
        );
      },
      (response) {
        Navigator.of(context).pop(true);
        widget.onUserBlocked?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.blockUserSuccess(widget.userName),
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: Colors.white,
              ),
            ),
            backgroundColor: colors.danger,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: colors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: Text(
        l10n.blockUserTitle,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        l10n.blockUserConfirmMessage(widget.userName),
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
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
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
          onPressed: _isLoading ? null : () => _handleBlock(context, colors, l10n),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.danger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: AppSpacing.lg,
                  height: AppSpacing.lg,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  l10n.blockUserAction,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }
}

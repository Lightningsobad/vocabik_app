import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/dialogs/report_user_dialog.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import 'block_user_dialog.dart';

class UserActionBottomSheet extends StatelessWidget {
  final String userId;
  final String userName;
  final VoidCallback? onUserBlocked;

  const UserActionBottomSheet({
    super.key,
    required this.userId,
    required this.userName,
    this.onUserBlocked,
  });

  static Future<void> show(
    BuildContext context, {
    required String userId,
    required String userName,
    VoidCallback? onUserBlocked,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => UserActionBottomSheet(
        userId: userId,
        userName: userName,
        onUserBlocked: onUserBlocked,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.sm2,
        bottom: AppSpacing.lg3 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: AppSpacing.xl4,
            height: AppSpacing.tn,
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.borderSubtle,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              userName,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.lg,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(color: colors.borderSubtle, height: 1.0),
          const SizedBox(height: AppSpacing.sm),

          // Option 1: Report
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.warningSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.flag,
                color: colors.warning,
                size: AppSpacing.lg2,
              ),
            ),
            title: Text(
              l10n.reportUserOption,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.warning,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              ReportUserDialog.show(
                context,
                targetId: userId,
                userName: userName,
                onUserBlocked: onUserBlocked,
              );
            },
          ),

          // Option 2: Block
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.dangerSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.userX,
                color: colors.danger,
                size: AppSpacing.lg2,
              ),
            ),
            title: Text(
              l10n.blockUserOption,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.danger,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              BlockUserDialog.show(
                context,
                userId: userId,
                userName: userName,
                onUserBlocked: onUserBlocked,
              );
            },
          ),
        ],
      ),
    );
  }
}

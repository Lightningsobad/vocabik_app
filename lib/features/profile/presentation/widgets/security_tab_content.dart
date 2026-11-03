import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'active_sessions_card.dart';
import 'setting_list_tile.dart';

class SecurityTabContent extends StatelessWidget {
  const SecurityTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Quản lý người dùng đã chặn (Nằm TRÊN phiên đăng nhập)
          SettingListTile(
            title: l10n.blockedUsersTitle,
            prefixWidget: Icon(
              LucideIcons.userX,
              size: AppSpacing.lg2,
              color: colors.textPrimary,
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
              size: AppSpacing.xl,
            ),
            onTap: () => context.push('/profile/blocked-users'),
          ),
          const SizedBox(height: AppSpacing.md),

          // 2. Phiên đăng nhập (Nằm DƯỚI)
          const ActiveSessionsCard(),
        ],
      ),
    );
  }
}

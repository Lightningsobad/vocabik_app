import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_font_size.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_style.dart';

class _NavigationItem {
  final String Function(AppLocalizations) getTitle;
  final String route;
  final bool isPush;

  const _NavigationItem({
    required this.getTitle,
    required this.route,
    this.isPush = false,
  });
}

class AppNavigationSheet extends StatelessWidget {
  const AppNavigationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AppNavigationSheet(),
    );
  }

  static const List<_NavigationItem> _items = [
    _NavigationItem(
      getTitle: _getHomeTitle,
      route: '/home',
    ),
    _NavigationItem(
      getTitle: _getDiscoverTitle,
      route: '/discover',
    ),
    _NavigationItem(
      getTitle: _getProgressTitle,
      route: '/progress',
    ),
    _NavigationItem(
      getTitle: _getProfileTitle,
      route: '/profile',
    ),
    _NavigationItem(
      getTitle: _getDailyChallengeTitle,
      route: '/home/daily-challenge',
    ),
    _NavigationItem(
      getTitle: _getLeaderboardTitle,
      route: '/progress/leaderboard',
    ),
    _NavigationItem(
      getTitle: _getAchievementsTitle,
      route: '/progress/achievements',
    ),
    _NavigationItem(
      getTitle: _getNotebookTitle,
      route: '/profile/notebook',
    ),
    _NavigationItem(
      getTitle: _getTermsTitle,
      route: '/terms-of-service',
      isPush: true,
    ),
    _NavigationItem(
      getTitle: _getPrivacyPolicyTitle,
      route: '/privacy-policy',
      isPush: true,
    ),
  ];

  static String _getHomeTitle(AppLocalizations l10n) => l10n.homeTitle;
  static String _getDiscoverTitle(AppLocalizations l10n) => l10n.discoverTitle;
  static String _getProgressTitle(AppLocalizations l10n) => l10n.progressTitle;
  static String _getProfileTitle(AppLocalizations l10n) => l10n.profileTitle;
  static String _getDailyChallengeTitle(AppLocalizations l10n) => l10n.actionDailyChallenge;
  static String _getLeaderboardTitle(AppLocalizations l10n) => l10n.actionLeaderboard;
  static String _getAchievementsTitle(AppLocalizations l10n) => l10n.actionAchievements;
  static String _getNotebookTitle(AppLocalizations l10n) => l10n.actionNotebook;
  static String _getTermsTitle(AppLocalizations l10n) => l10n.homeTerms;
  static String _getPrivacyPolicyTitle(AppLocalizations l10n) => l10n.homePrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.sm2,
        bottom: bottomPadding + AppSpacing.md,
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

          // Header title: Tất cả các trang
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.allPagesTitle,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    LucideIcons.x,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colors.borderSubtle, height: 1.0),

          // List of screens (No icons, each screen is a row in the list)
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, _) => Divider(
                color: colors.borderSubtle.withValues(alpha: 0.5),
                height: 1.0,
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return InkWell(
                  onTap: () {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    if (item.isPush) {
                      router.push(item.route);
                    } else {
                      router.go(item.route);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.getTitle(l10n),
                          style: AppTextStyles.custom(
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

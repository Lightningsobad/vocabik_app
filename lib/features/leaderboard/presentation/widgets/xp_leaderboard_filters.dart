import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class XpLeaderboardFilters extends StatelessWidget {
  final String selectedPeriod;
  final String selectedScope;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String> onScopeChanged;

  const XpLeaderboardFilters({
    super.key,
    required this.selectedPeriod,
    required this.selectedScope,
    required this.onPeriodChanged,
    required this.onScopeChanged,
  });

  static const List<String> periodKeys = ['this_week', 'last_week', 'this_month'];
  static const List<String> scopeKeys = ['global', 'friends'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);

    final periodLabels = [
      l10n?.xpLeaderboardFilterThisWeek ?? 'This week',
      l10n?.xpLeaderboardFilterLastWeek ?? 'Last week',
      l10n?.xpLeaderboardFilterThisMonth ?? 'This month',
    ];

    final periodIndex = periodKeys.indexOf(selectedPeriod);
    final validPeriodIndex = periodIndex >= 0 ? periodIndex : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Period Selector
        SharedSegmentedTabBar(
          selectedIndex: validPeriodIndex,
          onTabChanged: (index) {
            if (index >= 0 && index < periodKeys.length) {
              onPeriodChanged(periodKeys[index]);
            }
          },
          tabs: periodLabels,
        ),
        const SizedBox(height: AppSpacing.md),

        // 2. Scope Selector (Global / Friends with Icons)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              _buildScopeButton(
                context: context,
                colors: colors,
                isSelected: selectedScope == 'global',
                label: l10n?.xpLeaderboardFilterGlobal ?? 'Global',
                icon: SvgPicture.asset(
                  'assets/xp_leaderboard_screen/earth_icon.svg',
                  width: 18,
                  height: 18,
                ),
                onTap: () => onScopeChanged('global'),
              ),
              const SizedBox(width: AppSpacing.md),
              _buildScopeButton(
                context: context,
                colors: colors,
                isSelected: selectedScope == 'friends',
                label: l10n?.xpLeaderboardFilterFriends ?? 'Friends',
                icon: Image.asset(
                  'assets/xp_leaderboard_screen/people_icon.png',
                  width: 18,
                  height: 18,
                ),
                onTap: () => onScopeChanged('friends'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScopeButton({
    required BuildContext context,
    required AppColorsExtension colors,
    required bool isSelected,
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return BounceWrapper(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(
          minHeight: 39.0,
          minWidth: 42.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 5.0,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primaryAccent
              : colors.tabUnselectedBackground,
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: isSelected
                ? colors.primaryAccent
                : colors.tabUnselectedBorder,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: isSelected
                    ? colors.onPrimaryAccent
                    : colors.tabUnselectedText,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

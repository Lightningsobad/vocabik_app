import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import '../widgets/profile_action_grid.dart';
import '../widgets/user_profile_section.dart';
import '../widgets/preferences_tab_content.dart';
import '../widgets/subscription_tab_content.dart';
import '../widgets/security_tab_content.dart';
import '../widgets/account_tab_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          // Dự phòng 56px cho FAB tương lai + 32px đệm + safe area dưới cùng
          padding: EdgeInsets.only(bottom: 88.0 + MediaQuery.paddingOf(context).bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  l10n.profileSettingsTitle,
                  style: GoogleFonts.nunito(
                    color: colors.textPrimary,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              
              // Tab Bar
              SharedSegmentedTabBar(
                tabs: [l10n.profileTab, l10n.preferencesTab, l10n.subscriptionTab, l10n.securityTab, l10n.accountTab],
                selectedIndex: _selectedTabIndex,
                onTabChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              
              // Grid các nút hành động (Cố định ở mọi tab)
              const ProfileActionGrid(),
              const SizedBox(height: 24.0),
              
              // Content based on selected tab
              if (_selectedTabIndex == 0) ...[
                const UserProfileSection(),
              ] else if (_selectedTabIndex == 1) ...[
                const PreferencesTabContent(),
              ] else if (_selectedTabIndex == 2) ...[
                const SubscriptionTabContent(),
              ] else if (_selectedTabIndex == 3) ...[
                const SecurityTabContent(),
              ] else if (_selectedTabIndex == 4) ...[
                const AccountTabContent(),
              ] else ...[
                // Placeholder cho các tab khác
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      l10n.tabNotImplemented(_selectedTabIndex),
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

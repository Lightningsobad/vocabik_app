import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/app_header.dart';

import '../widgets/profile_tab_bar.dart';
import '../widgets/profile_action_grid.dart';
import '../widgets/user_profile_section.dart';

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

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeader(
              streak: 12,
              xp: 1240,
              currentLanguageCode: 'vi',
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  // Thêm bottom padding lớn để tránh bị che bởi Bottom Nav Bar và FAB
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24.0),
                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Profile & Settings',
                          style: GoogleFonts.nunito(
                            color: colors.textPrimary,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      
                      // Tab Bar
                      ProfileTabBar(
                        selectedIndex: _selectedTabIndex,
                        onTabChanged: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 24.0),
                      
                      // Content based on selected tab
                      if (_selectedTabIndex == 0) ...[
                        const ProfileActionGrid(),
                        const SizedBox(height: 32.0),
                        const UserProfileSection(),
                      ] else ...[
                        // Placeholder cho các tab khác
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Content for Tab $_selectedTabIndex is not implemented yet.',
                              style: TextStyle(color: colors.textSecondary),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

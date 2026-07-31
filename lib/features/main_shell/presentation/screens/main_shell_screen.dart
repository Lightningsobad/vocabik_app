import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return Scaffold(
      backgroundColor: colors.background,
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colors.surfaceCard,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: colors.textSecondary,
        selectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.home),
            label: l10n.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.compass),
            label: l10n.discoverTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.barChart3),
            label: l10n.progressTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.user),
            label: l10n.profileTitle,
          ),
        ],
      ),
    );
  }
}

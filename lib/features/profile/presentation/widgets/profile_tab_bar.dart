import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class ProfileTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const ProfileTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    final tabs = [
      'Profile',
      'Preferences',
      'Subscription',
      'Security',
      'Account'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BounceWrapper(
              onTap: () => onTabChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : colors.surfaceCard,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : colors.borderSubtle,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: GoogleFonts.inter(
                    color: isSelected 
                        ? (Theme.of(context).brightness == Brightness.dark ? AppColors.ink950 : Colors.white) 
                        : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

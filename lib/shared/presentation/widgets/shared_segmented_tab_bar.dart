import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class SharedSegmentedTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<String> tabs;

  const SharedSegmentedTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

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
                constraints: const BoxConstraints(minHeight: 48.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primaryAccent : colors.tabUnselectedBackground,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: isSelected ? colors.primaryAccent : colors.tabUnselectedBorder,
                    width: 1.0,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.nunito(
                    color: isSelected 
                        ? colors.onPrimaryAccent
                        : colors.tabUnselectedText,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15.0,
                  ),
                  child: Text(tabs[index]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

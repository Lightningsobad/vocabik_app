import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class SettingToggleButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  final String? prefixEmoji;
  final String? prefixText;

  const SettingToggleButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
    this.prefixEmoji,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BounceWrapper(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 48.0),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withValues(alpha: 0.1) : colors.background,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isActive ? primaryColor : colors.borderSubtle,
            width: 1.0,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixEmoji != null) ...[
              Text(
                prefixEmoji!,
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(width: 8.0),
            ],
            if (prefixText != null) ...[
              Text(
                prefixText!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4.0),
            ],
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isActive ? primaryColor : colors.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

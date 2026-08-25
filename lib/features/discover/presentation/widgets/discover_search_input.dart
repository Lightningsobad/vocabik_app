import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DiscoverSearchInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const DiscoverSearchInput({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: AppTextStyles.custom(
        color: colors.textPrimary,
        fontSize: AppFontSize.md,
      ),
      decoration: InputDecoration(
        hintText: l10n.discoverSearchHint,
        hintStyle: AppTextStyles.custom(
          color: colors.textSecondary,
          fontSize: AppFontSize.lg2,
        ),
        prefixIcon: Icon(
          LucideIcons.search,
          color: colors.textSecondary,
          size: 23,
        ),
        filled: true,
        fillColor: colors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17.0,
          vertical: 18.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: colors.inputBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: colors.inputBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

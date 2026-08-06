import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';

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
      style: GoogleFonts.nunito(
        color: colors.textPrimary,
        fontSize: AppFontSize.md,
      ),
      decoration: InputDecoration(
        hintText: l10n.discoverSearchHint,
        hintStyle: GoogleFonts.nunito(
          color: colors.textSecondary,
          fontSize: AppFontSize.md,
        ),
        prefixIcon: Icon(
          LucideIcons.search,
          color: colors.textSecondary,
          size: 20,
        ),
        filled: true,
        fillColor: colors.surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: colors.borderSubtle, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: colors.borderSubtle, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, 
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';

class NotebookSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;

  const NotebookSearchBar({
    super.key,
    required this.onChanged,
    this.initialValue = '',
  });

  @override
  State<NotebookSearchBar> createState() => _NotebookSearchBarState();
}

class _NotebookSearchBarState extends State<NotebookSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.inputBorder, width: 1.0),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (val) {
          setState(() {});
          widget.onChanged(val);
        },
        style: AppTextStyles.custom(
          fontSize: AppFontSize.md,
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: l10n.searchWordsPlaceholder,
          hintStyle: AppTextStyles.custom(
            fontSize: AppFontSize.lg,
            color: colors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colors.textSecondary,
            size: 22.0,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colors.textSecondary,
                    size: 20.0,
                  ),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                    widget.onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

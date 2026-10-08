import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ReportUserDialog extends StatefulWidget {
  final String userName;

  const ReportUserDialog({
    super.key,
    required this.userName,
  });

  static Future<void> show(BuildContext context, String userName) {
    return showDialog<void>(
      context: context,
      builder: (_) => ReportUserDialog(userName: userName),
    );
  }

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  int _selectedReasonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final reasons = [
      l10n.reportReasonInappropriateName,
      l10n.reportReasonInappropriateAvatar,
      l10n.reportReasonHarassmentOrCheating,
      l10n.reportReasonSpamOrAd,
    ];

    return AlertDialog(
      backgroundColor: colors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      title: Text(
        l10n.reportUserTitle,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportUserSubtitle(widget.userName),
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(reasons.length, (index) {
              final isSelected = _selectedReasonIndex == index;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedReasonIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? colors.primaryAccent
                            : colors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          reasons[index],
                          style: AppTextStyles.custom(
                            fontSize: AppFontSize.sm,
                            color: isSelected
                                ? colors.textPrimary
                                : colors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.actionCancel,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.md,
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.reportUserSuccessMessage),
                backgroundColor: colors.success,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.danger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(l10n.reportUserSubmit),
        ),
      ],
    );
  }
}


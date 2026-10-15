import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/auth_utils.dart';
import '../../../../features/moderation/domain/repositories/moderation_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_font_size.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_style.dart';

class ReportUserDialog extends StatefulWidget {
  final String targetId;
  final String userName;
  final String targetType;
  final VoidCallback? onUserBlocked;

  const ReportUserDialog({
    super.key,
    this.targetId = '',
    required this.userName,
    this.targetType = 'user',
    this.onUserBlocked,
  });

  static Future<void> show(
    BuildContext context, {
    String? targetId,
    required String userName,
    String targetType = 'user',
    VoidCallback? onUserBlocked,
  }) {
    final effectiveTargetId = targetId ?? userName;
    if (AuthUtils.isCurrentSelf(
      userId: effectiveTargetId,
      userName: userName,
      context: context,
    )) {
      return Future.value();
    }

    return showDialog<void>(
      context: context,
      builder: (_) => ReportUserDialog(
        targetId: effectiveTargetId,
        userName: userName,
        targetType: targetType,
        onUserBlocked: onUserBlocked,
      ),
    );
  }

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  int _selectedReasonIndex = 0;
  final TextEditingController _detailsController = TextEditingController();
  bool _isSubmitting = false;

  static const List<String> _reasonKeys = [
    'spam',
    'harassment',
    'inappropriate_content',
    'hate_speech',
    'other',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final repo = getIt<ModerationRepository>();
    final reason = _reasonKeys[_selectedReasonIndex];
    final details = _detailsController.text.trim();

    final result = await repo.submitReport(
      targetType: widget.targetType,
      targetId: widget.targetId,
      reason: reason,
      details: details.isNotEmpty ? details : null,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              failure.message,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: Colors.white,
              ),
            ),
            backgroundColor: colors.danger,
          ),
        );
      },
      (response) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isNotEmpty
                  ? response.message
                  : l10n.reportSuccess24h,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: Colors.white,
              ),
            ),
            backgroundColor: colors.success,
            duration: const Duration(seconds: 4),
          ),
        );

        // Prompt block option after successful report
        _showPostReportBlockPrompt(context, colors, l10n);
      },
    );
  }

  void _showPostReportBlockPrompt(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (promptContext) => AlertDialog(
        backgroundColor: colors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.blockUserPromptTitle,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.xl,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          l10n.blockUserPromptDesc,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.md,
            color: colors.textSecondary,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(promptContext).pop(),
            child: Text(
              l10n.actionLater,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(promptContext).pop();
              final repo = getIt<ModerationRepository>();
              final blockResult = await repo.blockUser(widget.targetId);
              if (!context.mounted) return;
              blockResult.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        failure.message,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.md,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: colors.danger,
                    ),
                  );
                },
                (_) {
                  widget.onUserBlocked?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.blockUserSuccess(widget.userName),
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.md,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: colors.danger,
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: Text(
              l10n.blockUserAction,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final reasons = [
      l10n.reportReasonSpam,
      l10n.reportReasonHarassment,
      l10n.reportReasonInappropriateContent,
      l10n.reportReasonHateSpeech,
      l10n.reportReasonOther,
    ];

    return AlertDialog(
      backgroundColor: colors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: Text(
        l10n.reportUserTitle,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
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
                  onTap: _isSubmitting
                      ? null
                      : () {
                          setState(() {
                            _selectedReasonIndex = index;
                          });
                        },
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.tnn,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? colors.primaryAccent
                              : colors.textSecondary,
                          size: AppSpacing.lg2,
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
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.reportDetailsLabel,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _detailsController,
                maxLength: 1000,
                maxLines: 3,
                enabled: !_isSubmitting,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l10n.reportDetailsHint,
                  hintStyle: AppTextStyles.custom(
                    fontSize: AppFontSize.sm,
                    color: colors.hintText,
                  ),
                  filled: true,
                  fillColor: colors.inputBackground,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: colors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: colors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: colors.primaryAccent),
                  ),
                  counterStyle: AppTextStyles.custom(
                    fontSize: AppFontSize.tnn,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
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
          onPressed: _isSubmitting
              ? null
              : () => _handleSubmit(context, colors, l10n),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.danger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          ),
          child: _isSubmitting
              ? SizedBox(
                  width: AppSpacing.lg,
                  height: AppSpacing.lg,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  l10n.reportUserSubmit,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }
}

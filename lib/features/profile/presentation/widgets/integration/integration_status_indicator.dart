import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

class IntegrationStatusIndicator extends StatelessWidget {
  const IntegrationStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    // Luôn hiển thị trạng thái Chưa kết nối theo yêu cầu hiện tại
    final statusColor = colors.textSecondary.withValues(alpha: 0.6);
    final statusText = l10n.statusNotConnected;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppSpacing.sm,
          height: AppSpacing.sm,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.5),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          statusText,
          style: GoogleFonts.nunito(
            color: colors.textSecondary,
            fontSize: AppSpacing.mdt,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

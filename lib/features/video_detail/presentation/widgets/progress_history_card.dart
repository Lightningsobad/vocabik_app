import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ProgressHistoryCard extends StatelessWidget {
  final VideoProgressEntity progress;

  const ProgressHistoryCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final dateStr = progress.completedAt != null
        ? DateFormat('dd/MM/yyyy').format(progress.completedAt!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg1,
        ),
        decoration: BoxDecoration(
          color: colors.historyCardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.historyCardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/video_detail/correct_icon.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            RichText(
              text: TextSpan(
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.mdt,
                  color: colors.textPrimary,
                ),
                children: [
                  TextSpan(text: '${l10n.videoDetailLastAttempt}: '),
                  TextSpan(
                    text: '${progress.accuracyScore}%',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  if (dateStr != null)
                    TextSpan(
                      text: ' · $dateStr',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

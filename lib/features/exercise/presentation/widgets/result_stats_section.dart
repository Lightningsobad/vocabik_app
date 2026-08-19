import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ResultStatsSection extends StatelessWidget {
  final ExerciseResultSummary summary;

  const ResultStatsSection({
    super.key,
    required this.summary,
  });

  String _getScoreIconPath(int score) {
    if (score >= 80) {
      return 'assets/result_screen/congratulation_icon.svg';
    } else if (score >= 50) {
      return 'assets/result_screen/like_icon.svg';
    } else {
      return 'assets/result_screen/strong_icon.svg';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final iconPath = _getScoreIconPath(summary.accuracyScore);

    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        // Score icon
        Center(
          child: SvgPicture.asset(
            iconPath,
            width: 72,
            height: 72,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Big percentage text
        Text(
          '${summary.accuracyScore}%',
          style: GoogleFonts.nunito(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: colors.primaryAccent,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Badges row: Correct / Wrong / Time
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Correct count
            _buildStatItem(
              icon: SvgPicture.asset(
                'assets/result_screen/correct_icon.svg',
                width: 16,
                height: 16,
              ),
              label: l10n.resultCorrectCount(summary.correctCount),
              textColor: colors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.md),

            // Wrong count
            _buildStatItem(
              icon: SvgPicture.asset(
                'assets/result_screen/wrong_icon.svg',
                width: 16,
                height: 16,
              ),
              label: l10n.resultWrongCount(summary.wrongCount),
              textColor: colors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.md),

            // Duration
            _buildStatItem(
              icon: Icon(
                Icons.access_time_rounded,
                size: 16,
                color: colors.textSecondary,
              ),
              label: _formatDuration(summary.duration),
              textColor: colors.textPrimary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildStatItem({
    required Widget icon,
    required String label,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: AppSpacing.tn),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/progress_history.dart';
import 'shimmer_block.dart';

class LearningHistoryCard extends StatelessWidget {
  final bool isLoading;
  final ProgressHistory? history;

  const LearningHistoryCard({super.key, this.isLoading = false, this.history});

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return l10n.progressDateToday;
    } else if (itemDate == today.subtract(const Duration(days: 1))) {
      return l10n.progressDateYesterday;
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final items = history?.items ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressLearningHistory,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.lg2,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading) ...[
          const ShimmerBlock(height: 56, borderRadius: 14.0),
          const SizedBox(height: 10),
          const ShimmerBlock(height: 56, borderRadius: 14.0),
          const SizedBox(height: 10),
          const ShimmerBlock(height: 56, borderRadius: 14.0),
        ] else if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.lg2),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Center(
              child: Text(
                l10n.progressNoLearningHistory,
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.mdt,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Row(
                  children: [
                    CourseTagBadge(
                      text: item.cefrLevel,
                      type: CourseTagType.level,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.videoTitle,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.lg2,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${item.accuracyScore}%',
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.lg2,
                        fontWeight: FontWeight.w800,
                        color: colors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl5),
                    Text(
                      _formatDate(item.completedAt, l10n),
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class ExerciseConfigSection extends StatelessWidget {
  const ExerciseConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<VideoDetailCubit, VideoDetailState>(
      builder: (context, state) {
        if (state is! VideoDetailLoaded) return const SizedBox.shrink();

        final selectedType = state.selectedExerciseType;
        final isMultipleChoice = selectedType == 'Multiple choice';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Type Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.borderSubtle, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isMultipleChoice ? Icons.checklist_rtl : Icons.keyboard_alt_outlined,
                          color: colors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          isMultipleChoice ? l10n.videoDetailMultipleChoice : l10n.videoDetailTypeTheAnswer,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.videoDetailExerciseType,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Segmented Toggle
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: BounceWrapper(
                        onTap: () {
                          context.read<VideoDetailCubit>().changeExerciseType('Multiple choice');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isMultipleChoice ? colors.background : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: isMultipleChoice
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.videoDetailFillBlank,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: isMultipleChoice ? FontWeight.bold : FontWeight.w600,
                              color: isMultipleChoice ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: BounceWrapper(
                        onTap: () {
                          context.read<VideoDetailCubit>().changeExerciseType('Type the answer');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isMultipleChoice ? colors.background : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: !isMultipleChoice
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.videoDetailTypeTheAnswer,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: !isMultipleChoice ? FontWeight.bold : FontWeight.w600,
                              color: !isMultipleChoice ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

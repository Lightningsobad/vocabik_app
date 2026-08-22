import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/features/video_detail/presentation/widgets/exercise_config_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/segmented_toggle.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ExerciseConfigSection extends StatelessWidget {
  const ExerciseConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<VideoDetailCubit, VideoDetailState>(
      builder: (context, state) {
        if (state is! VideoDetailLoaded) return const SizedBox.shrink();

        final selectedType = state.selectedExerciseType;
        final isMultipleChoice = selectedType == ExerciseType.multipleChoice;
        final blanksCount = state.blanksCount;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Two Cards Row: [Multiple choice | Dạng bài] and [20 chỗ trống | Độ dài]
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card 1: Dạng bài
                    Expanded(
                      child: ExerciseConfigCard(
                        iconPath: 'assets/video_detail/mc_icon.svg',
                        title: isMultipleChoice
                            ? l10n.videoDetailMultipleChoice
                            : l10n.videoDetailTypeTheAnswer,
                        subtitle: l10n.videoDetailExerciseType,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Card 2: Độ dài (Số chỗ trống)
                    Expanded(
                      child: ExerciseConfigCard(
                        iconPath: 'assets/video_detail/blank_icon.svg',
                        title: l10n.videoDetailBlanksCount(blanksCount),
                        subtitle: l10n.videoDetailLength,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg2),
              // Segmented Toggle Pill: Fill-blank | Tự gõ đáp án
              SegmentedToggle<ExerciseType>(
                selectedValue: selectedType,
                options: [
                  SegmentedToggleOption(
                    value: ExerciseType.multipleChoice,
                    label: l10n.videoDetailFillBlank,
                  ),
                  SegmentedToggleOption(
                    value: ExerciseType.typeTheAnswer,
                    label: l10n.videoDetailTypeTheAnswer,
                  ),
                ],
                onChanged: (type) {
                  context.read<VideoDetailCubit>().changeExerciseType(type);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

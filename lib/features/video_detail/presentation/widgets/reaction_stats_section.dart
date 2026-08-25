import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ReactionStatsSection extends StatelessWidget {
  const ReactionStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      VideoDetailCubit,
      VideoDetailState,
      Map<String, int>?
    >(
      selector: (state) {
        if (state is VideoDetailLoaded) {
          return state.video.reactionCounts;
        }
        return null;
      },
      builder: (context, reactionCounts) {
        if (reactionCounts == null) return const SizedBox.shrink();

        final pump = reactionCounts['PUMP'] ?? 0;
        final music = reactionCounts['MUSIC'] ?? 0;
        final study = reactionCounts['STUDY'] ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ReactionChip(
                iconAsset: 'assets/video_detail/strong_icon.svg',
                count: pump,
                reactionType: 'PUMP',
              ),
              _ReactionChip(
                iconAsset: 'assets/video_detail/music_icon.svg',
                count: music,
                reactionType: 'MUSIC',
              ),
              _ReactionChip(
                iconAsset: 'assets/video_detail/book_icon.svg',
                count: study,
                reactionType: 'STUDY',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReactionChip extends StatelessWidget {
  final String iconAsset;
  final int count;
  final String reactionType;

  const _ReactionChip({
    required this.iconAsset,
    required this.count,
    required this.reactionType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<VideoDetailCubit>().sendReaction(reactionType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md2,
          vertical: AppSpacing.sm2,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: colors.borderSubtle,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(iconAsset, width: 16, height: 16),
            const SizedBox(width: AppSpacing.sm),
            Text(
              count.toString(),
              style: AppTextStyles.custom(
                fontSize: AppFontSize.lg,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

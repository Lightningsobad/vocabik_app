import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class VersionSelector extends StatelessWidget {
  const VersionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoDetailCubit, VideoDetailState>(
      builder: (context, state) {
        if (state is! VideoDetailLoaded) return const SizedBox.shrink();

        final maxVersion = state.video.maxVersionNumber;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              _buildVersionCard(
                context,
                'v1',
                AppLocalizations.of(context)!.videoDetailVocabulary,
                state.selectedVersion,
                maxVersion,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildVersionCard(
                context,
                'v2',
                AppLocalizations.of(context)!.videoDetailGrammar,
                state.selectedVersion,
                maxVersion,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildVersionCard(
                context,
                'v3',
                AppLocalizations.of(context)!.videoDetailSpeed,
                state.selectedVersion,
                maxVersion,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVersionCard(
    BuildContext context,
    String version,
    String subtitle,
    String selectedVersion,
    int maxVersion,
  ) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isSelected = version == selectedVersion;

    final verNum =
        int.tryParse(version.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    final isLocked = verNum > maxVersion;

    Widget cardContent = Container(
      width: 105,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md3,
        vertical: AppSpacing.md2,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? colors.versionSelectedBackground
            : colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isSelected
              ? colors.versionSelectedBorder
              : colors.borderSubtle,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                version,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.w900,
                  color: isLocked ? colors.versionSubtitle : colors.textPrimary,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 6),
                SvgPicture.asset(
                  'assets/video_detail/lock_icon.svg',
                  width: 14,
                  height: 14,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.tn),
          Text(
            subtitle,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.tnn,
              fontWeight: FontWeight.normal,
              color: colors.versionSubtitle,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (isLocked) {
      return cardContent;
    }

    return BounceWrapper(
      onTap: () {
        context.read<VideoDetailCubit>().changeVersion(version);
      },
      child: cardContent,
    );
  }
}

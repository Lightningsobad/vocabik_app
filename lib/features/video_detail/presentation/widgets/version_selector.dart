import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class VersionSelector extends StatelessWidget {
  const VersionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoDetailCubit, VideoDetailState>(
      builder: (context, state) {
        if (state is! VideoDetailLoaded) return const SizedBox.shrink();

        final maxVersionStr = state.video.canonicalVersion ?? 'v1';
        final maxVersion = int.tryParse(maxVersionStr.replaceAll('v', '')) ?? 1;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              _buildVersionCard(context, 'v1', AppLocalizations.of(context)!.videoDetailVocabulary, state.selectedVersion, maxVersion),
              const SizedBox(width: AppSpacing.sm),
              _buildVersionCard(context, 'v2', AppLocalizations.of(context)!.videoDetailGrammar, state.selectedVersion, maxVersion),
              const SizedBox(width: AppSpacing.sm),
              _buildVersionCard(context, 'v3', AppLocalizations.of(context)!.videoDetailSpeed, state.selectedVersion, maxVersion),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVersionCard(BuildContext context, String version, String subtitle, String selectedVersion, int maxVersion) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isSelected = version == selectedVersion;
    
    final verNum = int.tryParse(version.replaceAll('v', '')) ?? 1;
    final isLocked = verNum > maxVersion;

    return BounceWrapper(
      onTap: () {
        if (!isLocked) {
          context.read<VideoDetailCubit>().changeVersion(version);
        }
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF06B6D4).withValues(alpha: 0.1) : colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF06B6D4) : colors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  version,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? colors.textSecondary : colors.textPrimary,
                  ),
                ),
                if (isLocked) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.lock, size: 14, color: const Color(0xFFF59E0B)),
                ]
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: isLocked ? colors.textSecondary : (isSelected ? const Color(0xFF06B6D4) : colors.textSecondary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

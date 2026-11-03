import 'package:flutter/material.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DiscoverPlaylistCard extends StatelessWidget {
  final PlaylistEntity playlist;
  final VoidCallback? onTap;

  const DiscoverPlaylistCard({
    super.key,
    required this.playlist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final isVi = l10n.localeName.startsWith('vi');

    final videoCountText = l10n.discoverVideosCount(playlist.videoCount);
    final durationText = isVi
        ? '~${playlist.approximateMinutes} phút'
        : '~${playlist.approximateMinutes} min';
    final subtitleText = '$videoCountText · $durationText';

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          children: [
            // Cover Image / Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: 120,
                height: 68,
                child: playlist.coverImageUrl != null &&
                        playlist.coverImageUrl!.isNotEmpty
                    ? Image.network(
                        playlist.coverImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackCover(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const AppShimmer(
                            child: ColoredBox(color: Colors.white),
                          );
                        },
                      )
                    : _buildFallbackCover(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Title & Subtitle Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    playlist.title,
                    style: AppTextStyles.custom(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.tn),
                  Text(
                    subtitleText,
                    style: AppTextStyles.custom(
                      color: colors.textSecondary,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Trailing Chevron
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6FB5),
            Color(0xFFA855F7),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.playlist_play_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

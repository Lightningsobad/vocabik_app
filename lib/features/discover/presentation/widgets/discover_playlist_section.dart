import 'package:flutter/material.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'discover_playlist_card.dart';

class DiscoverPlaylistSection extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<PlaylistEntity> playlists;
  final ValueChanged<PlaylistEntity>? onPlaylistTap;

  const DiscoverPlaylistSection({
    super.key,
    required this.title,
    required this.isLoading,
    required this.playlists,
    this.onPlaylistTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    if (!isLoading && playlists.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: title,
            size: SectionHeaderSize.medium,
            isLoading: isLoading,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: isLoading
                ? _buildLoadingSkeleton(colors)
                : Column(
                    children: playlists.map((playlist) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: DiscoverPlaylistCard(
                          playlist: playlist,
                          onTap: () => onPlaylistTap?.call(playlist),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(AppColorsExtension colors) {
    return AppShimmer(
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            height: 96,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      ),
    );
  }
}

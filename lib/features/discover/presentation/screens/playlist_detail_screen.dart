import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/features/discover/presentation/cubit/playlist_detail_cubit.dart';
import 'package:vocabik_app/features/discover/presentation/cubit/playlist_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String slug;

  const PlaylistDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<PlaylistDetailCubit>()..loadPlaylistDetail(slug),
      child: PlaylistDetailScreenView(slug: slug),
    );
  }
}

class PlaylistDetailScreenView extends StatelessWidget {
  final String slug;

  const PlaylistDetailScreenView({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<PlaylistDetailCubit, PlaylistDetailState>(
          builder: (context, state) {
            if (state is PlaylistDetailLoading ||
                state is PlaylistDetailInitial) {
              return _buildSkeleton(colors);
            }

            if (state is PlaylistDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.discoverErrorLoad,
                        style: AppTextStyles.custom(
                          color: colors.textPrimary,
                          fontSize: AppFontSize.lg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PlaylistDetailCubit>()
                              .loadPlaylistDetail(slug);
                        },
                        child: Text(l10n.discoverRetryButton),
                      ),
                    ],
                  ),
                ),
              );
            }

            final playlist = (state as PlaylistDetailLoaded).playlist;
            return _buildContent(context, playlist, colors, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PlaylistEntity playlist,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    final isVi = l10n.localeName.startsWith('vi');
    final minutesText = isVi
        ? '~${playlist.approximateMinutes} phút'
        : '~${playlist.approximateMinutes} min';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    isVi ? 'Quay lại' : 'Back',
                    style: AppTextStyles.custom(
                      color: colors.textSecondary,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Cover Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: AspectRatio(
              aspectRatio: 21 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (playlist.coverImageUrl != null &&
                      playlist.coverImageUrl!.isNotEmpty)
                    Image.network(
                      playlist.coverImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildGradientBanner(),
                    )
                  else
                    _buildGradientBanner(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.tn,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x99070710),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        '✓ Admin Curated',
                        style: AppTextStyles.custom(
                          color: Colors.white,
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            playlist.title,
            style: AppTextStyles.custom(
              color: colors.textPrimary,
              fontSize: AppFontSize.xl4,
              fontWeight: FontWeight.w900,
            ),
          ),

          // Description
          if (playlist.description != null &&
              playlist.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              playlist.description!,
              style: AppTextStyles.custom(
                color: colors.textSecondary,
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm2),

          // Metadata row
          Wrap(
            spacing: AppSpacing.lg,
            children: [
              Text(
                '📹 ${l10n.discoverVideosCount(playlist.videoCount)}',
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '⏱ $minutesText',
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Video Cards Grid / List
          if (playlist.videos.isNotEmpty) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlist.videos.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final video = playlist.videos[index];
                return SizedBox(
                  height: 263,
                  child: SharedCourseCard(
                    video: video,
                    width: double.infinity,
                  ),
                );
              },
            ),
          ] else ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l10n.emptyVideos,
                  style: AppTextStyles.custom(
                    color: colors.textSecondary,
                    fontSize: AppFontSize.md,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildGradientBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6FB5),
            Color(0xFFA855F7),
            Color(0xFF4D9FFF),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(AppColorsExtension colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AspectRatio(
              aspectRatio: 21 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 200,
              height: 28,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 150,
              height: 18,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

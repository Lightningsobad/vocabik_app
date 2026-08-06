import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class MockPlaylistModel {
  final String id;
  final String title;
  final int videoCount;
  final String duration;
  final List<Color> gradientColors;

  MockPlaylistModel({
    required this.id,
    required this.title,
    required this.videoCount,
    required this.duration,
    required this.gradientColors,
  });
}

class PlaylistCard extends StatelessWidget {
  final MockPlaylistModel playlist;
  final VoidCallback? onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    
    return BounceWrapper(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: playlist.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    style: GoogleFonts.nunito(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.mdt,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${l10n.discoverVideosCount(playlist.videoCount)} · ${playlist.duration}',
                    style: GoogleFonts.nunito(
                      color: colors.textSecondary,
                      fontSize: AppFontSize.sm,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              LucideIcons.chevronRight,
              color: colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class IconActionCard extends StatelessWidget {
  final String title;
  final String emoji;
  final VoidCallback onTap;
  final int badgeCount;
  final bool hasNotification;

  const IconActionCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.onTap,
    this.badgeCount = 0,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft, // Đảm bảo nội dung căn giữa chiều dọc
          children: [
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.nunito( // Dùng font Nunito
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                    maxLines: null, // Allow wrapping if text scales up
                  ),
                ),
              ],
            ),
            if (badgeCount > 0 || hasNotification)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: badgeCount > 0
                      ? Text(
                          badgeCount.toString(),
                          style: GoogleFonts.nunito(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox(width: 4, height: 4),
                ),
              ),
          ],

        ),
      ),
    );
  }
}

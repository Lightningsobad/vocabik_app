import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';

class SessionItemWidget extends StatelessWidget {
  final IconData icon;
  final String deviceName;
  final String osName;
  final String timeText;

  const SessionItemWidget({
    super.key,
    required this.icon,
    required this.deviceName,
    required this.osName,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              icon,
              color: colors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: GoogleFonts.nunito(
                    color: colors.textPrimary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  osName,
                  style: GoogleFonts.nunito(
                    color: colors.textSecondary,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeText,
            style: GoogleFonts.nunito(
              color: colors.textSecondary,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}

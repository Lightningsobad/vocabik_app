import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class SessionItemWidget extends StatelessWidget {
  final UserSession session;

  const SessionItemWidget({
    super.key,
    required this.session,
  });

  bool _isMobileDevice(String device) {
    final d = device.toLowerCase();
    return d.contains('di động') ||
        d.contains('mobile') ||
        d.contains('phone') ||
        d.contains('iphone') ||
        d.contains('android') ||
        d.contains('ios') ||
        d.contains('ipad');
  }

  String _formatTimeText(BuildContext context) {
    if (session.current) {
      return 'Now';
    }
    final time = session.lastActive ?? session.createdAt;
    if (time == null) return '';

    final now = DateTime.now().toUtc();
    final diff = now.difference(time.toUtc());
    final isVi = Localizations.localeOf(context).languageCode == 'vi';

    if (diff.inSeconds < 60) {
      return isVi ? 'Vừa xong' : 'Just now';
    } else if (diff.inMinutes < 60) {
      return isVi ? '${diff.inMinutes}m trước' : '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return isVi ? '${diff.inHours}h trước' : '${diff.inHours}h ago';
    } else if (diff.inDays < 30) {
      return isVi ? '${diff.inDays}d trước' : '${diff.inDays}d ago';
    } else {
      final localTime = time.toLocal();
      return '${localTime.day.toString().padLeft(2, '0')}/${localTime.month.toString().padLeft(2, '0')}/${localTime.year}';
    }
  }

  String _formatSessionTitle(String device, String timeText) {
    const separator = ' · ';
    final cleanDevice = device.trim();
    if (cleanDevice.isEmpty) {
      return timeText;
    }

    String devicePart = cleanDevice;
    if (cleanDevice.contains(' trên ')) {
      final parts = cleanDevice.split(' trên ');
      devicePart = '${parts[0].trim()}$separator${parts[1].trim()}';
    } else if (cleanDevice.contains(' on ')) {
      final parts = cleanDevice.split(' on ');
      devicePart = '${parts[0].trim()}$separator${parts[1].trim()}';
    }

    if (timeText.isEmpty) {
      return devicePart;
    }
    return '$devicePart$separator$timeText';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isMobile = _isMobileDevice(session.device);
    final icon = isMobile ? LucideIcons.smartphone : LucideIcons.globe;
    final iconColor = isMobile ? const Color(0xFF818CF8) : const Color(0xFF38BDF8);

    final timeText = _formatTimeText(context);
    final displayText = _formatSessionTitle(session.device, timeText);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20.0,
            color: iconColor,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              displayText,
              style: GoogleFonts.nunito(
                color: colors.textSecondary,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

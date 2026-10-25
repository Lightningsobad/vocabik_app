import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_font_size.dart';
import '../../../theme/app_text_style.dart';

/// Các loại thông báo được hỗ trợ.
enum AppSnackBarType {
  success,
  error,
  warning,
  info,
}

/// Helper hiển thị SnackBar dạng thẻ nổi tùy chỉnh theo Design System.
class AppSnackBar {
  AppSnackBar._();

  /// Hiển thị thông báo dạng thẻ nổi.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    String? title,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    // Dọn dẹp hàng đợi chuyển cảnh trước khi hiện thông báo mới
    messenger.clearSnackBars();

    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        dismissDirection: DismissDirection.horizontal,
        duration: duration,
        content: _AppSnackBarCard(
          title: title,
          message: message,
          type: type,
          action: action,
          onClose: () => messenger.hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Hiển thị thông báo thành công (Success).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.success,
      duration: duration,
      action: action,
    );
  }

  /// Hiển thị thông báo lỗi (Error).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.error,
      duration: duration,
      action: action,
    );
  }

  /// Hiển thị thông báo cảnh báo (Warning).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.warning,
      duration: duration,
      action: action,
    );
  }

  /// Hiển thị thông báo thông tin (Info).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
  }) {
    return show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.info,
      duration: duration,
      action: action,
    );
  }
}

/// Card giao diện hiển thị bên trong SnackBar.
class _AppSnackBarCard extends StatelessWidget {
  final String? title;
  final String message;
  final AppSnackBarType type;
  final Widget? action;
  final VoidCallback onClose;

  const _AppSnackBarCard({
    this.title,
    required this.message,
    required this.type,
    this.action,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>() ??
        AppColorsExtension.light;

    final IconData iconData;
    final Color badgeBgColor;
    final Color badgeIconColor;
    final Color borderColor;

    switch (type) {
      case AppSnackBarType.success:
        iconData = Icons.check_circle_outline_rounded;
        badgeBgColor = colors.successBackground;
        badgeIconColor = colors.success;
        borderColor = colors.success.withValues(alpha: 0.35);
        break;
      case AppSnackBarType.error:
        iconData = Icons.error_outline_rounded;
        badgeBgColor = colors.dangerSoft;
        badgeIconColor = colors.danger;
        borderColor = colors.danger.withValues(alpha: 0.35);
        break;
      case AppSnackBarType.warning:
        iconData = Icons.warning_amber_rounded;
        badgeBgColor = colors.warningSoft;
        badgeIconColor = colors.warning;
        borderColor = colors.warning.withValues(alpha: 0.35);
        break;
      case AppSnackBarType.info:
        iconData = Icons.info_outline_rounded;
        badgeBgColor = colors.infoSoft;
        badgeIconColor = colors.primaryAccent;
        borderColor = colors.primaryAccent.withValues(alpha: 0.35);
        break;
    }

    final hasTitle = title != null && title!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment:
            hasTitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Icon Badge 36x36 bo tròn 10
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                iconData,
                color: badgeIconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nội dung text: Tiêu đề (tùy chọn) + mô tả
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasTitle) ...[
                  Text(
                    title!,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.sm,
                    color: hasTitle ? colors.textSecondary : colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Widget action tùy chọn (ví dụ: nút Retry)
          if (action != null) ...[
            const SizedBox(width: 8),
            action!,
          ],

          const SizedBox(width: 8),

          // Nút đóng
          GestureDetector(
            key: const Key('app_snack_bar_close_button'),
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

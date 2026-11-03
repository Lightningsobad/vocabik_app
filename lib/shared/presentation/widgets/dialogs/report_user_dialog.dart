import 'package:flutter/material.dart';
import 'report_content_dialog.dart';

export 'report_content_dialog.dart';

class ReportUserDialog extends StatelessWidget {
  final String targetId;
  final String userName;
  final String targetType;
  final VoidCallback? onUserBlocked;

  const ReportUserDialog({
    super.key,
    this.targetId = '',
    required this.userName,
    this.targetType = 'user',
    this.onUserBlocked,
  });

  static Future<void> show(
    BuildContext context, {
    String? targetId,
    required String userName,
    String targetType = 'user',
    VoidCallback? onUserBlocked,
  }) {
    return ReportContentDialog.show(
      context,
      targetId: targetId,
      targetTitle: userName,
      targetType: targetType,
      onUserBlocked: onUserBlocked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReportContentDialog(
      targetId: targetId,
      targetTitle: userName,
      targetType: targetType,
      onUserBlocked: onUserBlocked,
    );
  }
}

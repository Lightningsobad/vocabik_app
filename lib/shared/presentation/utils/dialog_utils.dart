import 'package:flutter/material.dart';

class DialogUtils {
  static bool _isLoadingShowing = false;

  static void showLoading(BuildContext context) {
    if (_isLoadingShowing) return;
    _isLoadingShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ).then((_) {
      _isLoadingShowing = false;
    });
  }

  static void hideLoading(BuildContext context) {
    if (_isLoadingShowing) {
      _isLoadingShowing = false;
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}

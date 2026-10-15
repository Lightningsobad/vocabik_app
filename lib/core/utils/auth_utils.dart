import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection.dart';
import '../../features/auth/data/data_sources/auth_local_data_source.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class AuthUtils {
  AuthUtils._();

  /// Returns the currently logged-in user ID, or null if unauthenticated.
  static String? getCurrentUserId([BuildContext? context]) {
    if (context != null) {
      try {
        final user = context.read<AuthBloc>().state.user;
        if (user != null && user.id.isNotEmpty) return user.id;
      } catch (_) {}
    }
    try {
      if (getIt.isRegistered<AuthBloc>()) {
        final user = getIt<AuthBloc>().state.user;
        if (user != null && user.id.isNotEmpty) return user.id;
      }
    } catch (_) {}
    try {
      if (getIt.isRegistered<AuthLocalDataSource>()) {
        final user = getIt<AuthLocalDataSource>().getUser();
        if (user != null && user.id.isNotEmpty) return user.id;
      }
    } catch (_) {}
    return null;
  }

  /// Checks if the given [userId] or [userName] belongs to the currently logged-in user.
  static bool isCurrentSelf({
    String? userId,
    String? userName,
    BuildContext? context,
  }) {
    // 1. Try matching by ID first (most accurate)
    final currentId = getCurrentUserId(context);
    if (currentId != null && currentId.isNotEmpty && userId != null && userId.isNotEmpty) {
      if (currentId == userId) return true;
    }

    // 2. Fast check for literal 'You'
    if (userName != null && userName.trim().toLowerCase() == 'you') {
      return true;
    }

    // 3. Fallback check by display name
    String? currentDisplayName;
    if (context != null) {
      try {
        currentDisplayName = context.read<AuthBloc>().state.user?.displayName;
      } catch (_) {}
    }
    if (currentDisplayName == null) {
      try {
        if (getIt.isRegistered<AuthBloc>()) {
          currentDisplayName = getIt<AuthBloc>().state.user?.displayName;
        }
      } catch (_) {}
    }
    if (currentDisplayName == null) {
      try {
        if (getIt.isRegistered<AuthLocalDataSource>()) {
          currentDisplayName = getIt<AuthLocalDataSource>().getUser()?.displayName;
        }
      } catch (_) {}
    }

    if (currentDisplayName != null && currentDisplayName.isNotEmpty) {
      if (userName != null && userName.isNotEmpty && userName == currentDisplayName) {
        return true;
      }
      if (userId != null && userId.isNotEmpty && userId == currentDisplayName) {
        return true;
      }
    }

    return false;
  }
}

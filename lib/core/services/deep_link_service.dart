import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class DeepLinkService {
  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  // Stream controller để phát broadcast token ra ngoài cho UI/Router lắng nghe
  final _tokenController = StreamController<String>.broadcast();
  Stream<String> get onTokenReceived => _tokenController.stream;

  final _resetPasswordTokenController = StreamController<String>.broadcast();
  Stream<String> get onResetPasswordTokenReceived =>
      _resetPasswordTokenController.stream;

  DeepLinkService() : _appLinks = AppLinks();

  void init() {
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      // Handle the initial link (app opened from closed state)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      // Handle subsequent links (app opened from background)
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          _handleUri(uri);
        },
        onError: (err) {
          if (kDebugMode) {
            debugPrint('DeepLink Error: $err');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('DeepLink Initialization Error: $e');
      }
    }
  }

  void _handleUri(Uri uri) {
    if (kDebugMode) {
      debugPrint('Received DeepLink: ${uri.scheme}://${uri.host}${uri.path}');
    }
    // Expected link format: https://vocabik.com/auth/verify-email?token=xxx or vocabik://verify-email?token=xxx
    if (uri.path.contains('/auth/verify-email') ||
        uri.path.contains('/verify-email') ||
        uri.host == 'verify-email') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        _tokenController.add(token);
      }
    } else if (uri.path.contains('/reset-password') ||
        uri.path.contains('/auth/reset-password') ||
        uri.host == 'reset-password') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        _resetPasswordTokenController.add(token);
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
    _tokenController.close();
    _resetPasswordTokenController.close();
  }
}

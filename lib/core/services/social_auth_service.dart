import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class SocialAuthService {
  Future<String?> getGoogleIdToken();
  Future<void> signOut();
}

@LazySingleton(as: SocialAuthService)
class GoogleAuthServiceImpl implements SocialAuthService {
  static const String _googleClientId =
      '279107911867-9gc8jc0retm3e0de609t3g8171qege8o.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  GoogleAuthServiceImpl() : _googleSignIn = GoogleSignIn.instance;

  @visibleForTesting
  GoogleAuthServiceImpl.forTesting(this._googleSignIn);

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        debugPrint('[GoogleAuthService] Initializing GoogleSignIn with serverClientId: $_googleClientId');
        await _googleSignIn.initialize(
          serverClientId: _googleClientId,
        );
        _isInitialized = true;
        debugPrint('[GoogleAuthService] GoogleSignIn initialized successfully');
      } catch (e, stack) {
        debugPrint('[GoogleAuthService] Failed to initialize GoogleSignIn: $e\n$stack');
        rethrow;
      }
    }
  }

  @override
  Future<String?> getGoogleIdToken() async {
    try {
      if (kDebugMode) {
        debugPrint('[GoogleAuthService] Starting Google Sign-In flow...');
      }
      await _ensureInitialized();
      final account = await _googleSignIn.authenticate();
      if (kDebugMode) {
        debugPrint('[GoogleAuthService] Google Authenticate success');
      }
      final idToken = account.authentication.idToken;
      if (kDebugMode) {
        debugPrint('[GoogleAuthService] idToken received: ${idToken != null && idToken.isNotEmpty ? "YES (length: ${idToken.length})" : "NO/NULL"}');
      }
      return idToken;
    } on GoogleSignInException catch (e, stack) {
      if (kDebugMode) {
        debugPrint(
          '[GoogleAuthService] GoogleSignInException: code=${e.code}, description=${e.description}\n$stack',
        );
      }
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        if (kDebugMode) {
          debugPrint('[GoogleAuthService] User cancelled/interrupted Google Sign-In.');
        }
        return null;
      }
      throw Exception('Google SDK [${e.code}]: ${e.description ?? 'Unknown error'}');
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[GoogleAuthService] Unexpected error in getGoogleIdToken: $e\n$stack');
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await _googleSignIn.signOut();
      if (kDebugMode) {
        debugPrint('[GoogleAuthService] Google signOut completed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GoogleAuthService] signOut error: $e');
      }
    }
  }
}

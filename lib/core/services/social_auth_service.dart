import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class SocialAuthService {
  Future<String?> getGoogleIdToken();
  Future<void> signOut();
}

@LazySingleton(as: SocialAuthService)
class GoogleAuthServiceImpl implements SocialAuthService {
  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  GoogleAuthServiceImpl() : _googleSignIn = GoogleSignIn.instance;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        serverClientId:
            '279107911867-8264icmn4fndpq9c6t5jakcjol5n9sv9.apps.googleusercontent.com',
      );
      _isInitialized = true;
    }
  }

  @override
  Future<String?> getGoogleIdToken() async {
    try {
      await _ensureInitialized();
      final account = await _googleSignIn.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}

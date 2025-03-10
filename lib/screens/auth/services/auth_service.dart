import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sahai/models/user_model.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Sign in cancelled by user');
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw AuthException('Failed to get Google authentication tokens');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw AuthException('Failed to authenticate with Firebase');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;

    final email = user.email ?? '';
    return UserModel(
      uid: user.uid,
      email: email,
      userType: _isPesuEmail(email) ? 'pesu' : 'guest',
    );
  }

  Future<void> signOut() async {
    try {
      if (_auth.currentUser != null) {
        await Future.wait([
          _googleSignIn.signOut(),
          _auth.signOut(),
        ]);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException('Logout failed: ${_handleFirebaseAuthError(e)}');
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  bool _isPesuEmail(String email) {
    return email.endsWith('@pesu.pes.edu') || email.endsWith('@pes.edu');
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Account already exists with different credentials';
      case 'invalid-credential':
        return 'Invalid authentication credentials';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

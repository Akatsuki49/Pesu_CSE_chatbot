import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahai/models/user_model.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  String? getProfileImageUrl() {
    User? user = _auth.currentUser;
    return user?.photoURL;
  }

  String? getUserName() {
    User? user = _auth.currentUser;
    if (user != null && user.displayName != null) {
      // Extract names from the full name
      final names = user.displayName!.split(' ');
      if (names.length >= 2) {
        // Capitalize the first and second names
        final firstName = _capitalize(names[0]);
        final secondName = _capitalize(names[1]);
        return '$firstName $secondName';
      } else if (names.isNotEmpty) {
        // If there's only one name, capitalize it
        return _capitalize(names.first);
      }
    }
    return null; // Return null if user name is not available
  }

  String? getUserEmail() {
    User? user = _auth.currentUser;
    return user?.email;
  }

  // Helper method to capitalize the first letter of a word
  String _capitalize(String word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        userType:
            user.email?.endsWith('@pesu.pes.edu') == true ? 'pesu' : 'guest',
      );
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

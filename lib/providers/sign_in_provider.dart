import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Future<bool> isUserLoggedIn() async {
    // Listen to the auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        // Perform actions if the user is signed out
      } else {
        print('User is signed in!');
        // Perform actions if the user is signed in, such as redirecting to a home screen
      }
    });
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }

  Future<User?> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
        await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        print("User Name: ${user!.displayName}");

        return user;
      } else {
        print("User cancelled the login");

        return null;
      }
    } catch (error) {

      print("Error signing in with Google: $error");
      return null;
    }
  }

  Future<void> handleSignOut() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
      print("User signed out successfully");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  // You can add more methods like signInWithEmailPassword, signUp, etc. as needed

  // Add a method to check the authentication state
  bool isUserSignedIn() {
    return currentUser != null;
  }
}

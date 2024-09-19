import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final Stream<User?> authStream =
      FirebaseAuth.instance.authStateChanges();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<void> googleSignIn(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Start the Google Sign-In process
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      print("first step");
      if (googleSignInAccount != null) {
        // Retrieve authentication details
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        print("second step");
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        print("third step");
        // Sign in to Firebase with the credential
        await firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Sign-in failed: ${e.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      ));
    } finally {
      // Dismiss the loading indicator
      Navigator.of(context).pop();
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}

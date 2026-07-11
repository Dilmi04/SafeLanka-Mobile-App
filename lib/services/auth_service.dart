import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  // Using getters to ensure we always get the latest instance and
  // to avoid issues if initialization happens later (though it should be done in main)
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // Google sign in configuration
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId: '886931493603-8qd9c12fqh6ert28ref1tkl9ue1p4ntg.apps.googleusercontent.com',
  );

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Register with email & password ───────────────────────────────────────
  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);

        // Save user data to Firestore
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': '',
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ─── Sign in with email & password ────────────────────────────────────────
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────────
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null) {
        try {
          // Check if user exists in Firestore
          final doc = await _db.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            // Create user document if it doesn't exist
            await _db.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'name': user.displayName ?? '',
              'email': user.email ?? '',
              'phone': '',
              'createdAt': FieldValue.serverTimestamp(),
              'photoUrl': user.photoURL ?? '',
            });
          }
        } catch (firestoreError) {
          debugPrint('Firestore save error: $firestoreError');
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      throw Exception('Google sign-in failed');
    }
  }

  // ─── Reset Password ───────────────────────────────────────────────────────
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    try {
      // 1. Sign out from Firebase
      await _auth.signOut();

      // 2. Sign out from Google if applicable
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
        }
      } catch (googleError) {
        debugPrint('Google sign-out error: $googleError');
      }
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  // ─── Get user profile from Firestore ──────────────────────────────────────
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;
    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      return doc.data();
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // ─── Update user profile ──────────────────────────────────────────────────
  Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      await user.updateDisplayName(name);
      await _db.collection('users').doc(user.uid).update({
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // ─── Error handler ────────────────────────────────────────────────────────
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}

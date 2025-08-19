import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    bool createProfileDoc = true,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    await cred.user?.updateDisplayName(name.trim());

    if (createProfileDoc) {
      final userDoc = _db.collection('users').doc(cred.user!.uid);

      try {
        await userDoc.set({
          'name': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        await userDoc.collection('settings').doc('theme_color').set({
          'colorValue': 427041274,
        });
      } on FirebaseException catch (e) {
        debugPrint("Firestore write failed: ${e.message}");
        throw FirebaseAuthException(
          code: 'firestore-failed',
          message: 'Signup succeeded, but failed to save profile. Try again.',
        );
      }
    }

    return cred;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> sendPasswordReset({required String email}) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _auth.signOut();

  Stream<User?> auth$() => _auth.authStateChanges();
}

String mapAuthError(Object e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'Use a stronger password (min 6).';
      case 'too-many-requests':
        return 'Too many attempts, try later.';
      case 'network-request-failed':
        return 'Network error, check connection.';
      case 'firestore-failed':
        return 'Profile creation failed. Please try again.';
    }
    return e.message ?? 'Authentication error';
  }
  return 'Something went wrong';
}

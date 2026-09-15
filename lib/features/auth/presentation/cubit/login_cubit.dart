import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(LoginInitial());

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _googleInitialized = false;

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> loginWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      final User? user = credential.user;
      if (user == null) {
        emit(LoginFailure('Login failed, please try again'));
        return;
      }
      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_authErrorMessage(e)));
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await googleSignIn.initialize();
        _googleInitialized = true;
      }

      if (!googleSignIn.supportsAuthenticate()) {
        emit(LoginFailure('Google sign in is not supported on this device'));
        return;
      }

      final GoogleSignInAccount account = await googleSignIn.authenticate();
      final String? idToken = account.authentication.idToken;
      if (idToken == null) {
        emit(LoginFailure('Could not read Google credentials, check the app configuration'));
        return;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) {
        emit(LoginFailure('Login failed, please try again'));
        return;
      }

      await _saveUserProfile(user, account);
      emit(LoginSuccess(user));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(LoginInitial());
        return;
      }
      emit(LoginFailure(e.description ?? 'Google sign in failed'));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_authErrorMessage(e)));
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> sendPasswordResetEmail() async {
    final String email = emailController.text.trim();
    if (validateEmail(email) != null) {
      emit(LoginFailure('Please enter a valid email first'));
      return;
    }

    emit(LoginLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(PasswordResetEmailSent(email));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_authErrorMessage(e)));
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> _saveUserProfile(User user, GoogleSignInAccount account) async {
    final DocumentReference<Map<String, dynamic>> userRef =
        _firestore.collection('users').doc(user.uid);
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();

    if (snapshot.exists) return;

    await userRef.set({
      'uid': user.uid,
      'name': account.displayName ?? user.displayName ?? '',
      'email': account.email,
      'phone': user.phoneNumber ?? '',
      'avatarIndex': 1,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String _authErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'This email address is not valid';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Wrong email or password';
      case 'too-many-requests':
        return 'Too many attempts, please try again later';
      case 'network-request-failed':
        return 'Network error, please check your connection';
      case 'operation-not-allowed':
        return 'This sign in method is disabled for this project';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email';
      default:
        return exception.message ?? 'Authentication failed';
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

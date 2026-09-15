import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> loginWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      emit(LoginSuccess(result.user!));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(errorMessage(e)));
    } catch (e) {
      emit(LoginFailure('Something went wrong, please try again'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      await GoogleSignIn.instance.initialize();
      final account = await GoogleSignIn.instance.authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final result = await auth.signInWithCredential(credential);

      await saveUser(result.user!, account);
      emit(LoginSuccess(result.user!));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(LoginInitial());
      } else {
        emit(LoginFailure('Google sign in failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(errorMessage(e)));
    } catch (e) {
      emit(LoginFailure('Something went wrong, please try again'));
    }
  }

  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();
    if (validateEmail(email) != null) {
      emit(LoginFailure('Please enter a valid email first'));
      return;
    }

    emit(LoginLoading());
    try {
      await auth.sendPasswordResetEmail(email: email);
      emit(PasswordResetEmailSent(email));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(errorMessage(e)));
    }
  }

  Future<void> saveUser(User user, GoogleSignInAccount account) async {
    final doc = firestore.collection('users').doc(user.uid);
    if ((await doc.get()).exists) return;

    await doc.set({
      'uid': user.uid,
      'name': account.displayName ?? '',
      'email': account.email,
      'phone': '',
      'avatarIndex': 1,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String errorMessage(FirebaseAuthException e) {
    switch (e.code) {
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
        return 'This sign in method is disabled';
      default:
        return 'Authentication failed';
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

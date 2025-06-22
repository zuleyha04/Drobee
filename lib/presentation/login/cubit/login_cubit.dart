import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth;

  LoginCubit({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(LoginInitial());

  void emitLoading() {
    emit(LoginLoading());
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure('Email and password cannot be empty'));
      return;
    }

    emit(LoginLoading());

    try {
      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      if (result.user != null) {
        emit(LoginSuccess(result.user!));
      } else {
        emit(LoginFailure('Login failed!'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_mapFirebaseErrorToMessage(e)));
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        emit(LoginInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(LoginSuccess(userCredential.user!));
      } else {
        emit(LoginFailure('Google sign-in failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_mapFirebaseErrorToMessage(e)));
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(LoginInitial());
  }

  String _mapFirebaseErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      default:
        return 'Error: ${e.message ?? 'Unknown error'}';
    }
  }
}

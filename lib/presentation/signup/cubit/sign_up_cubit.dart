import 'package:drobee/presentation/signup/cubit/sign_up_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _firebaseAuth;

  SignupCubit({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(SignupInitial());

  Future<void> signUpWithGoogle() async {
    emit(SignupLoading());

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        emit(SignupInitial());
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
        emit(SignupSuccess(userCredential.user!));
      } else {
        emit(SignupFailure('Sign up with Google failed.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(SignupFailure(_mapFirebaseErrorToMessage(e)));
    } catch (e) {
      emit(SignupFailure('Unexpected error: ${e.toString()}'));
    }
  }

  String _mapFirebaseErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'operation-not-allowed':
        return 'This operation is disabled';
      default:
        return 'Error: ${e.message ?? 'Unknown error'}';
    }
  }

  void reset() => emit(SignupInitial());
}

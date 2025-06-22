import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/error_handler.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(CreateAccountInitial());

  void emitLoading() {
    emit(CreateAccountLoading());
  }

  Future<void> createAccount(String email, String password) async {
    final validationError = _validateInputs(email, password);
    if (validationError != null) {
      emit(CreateAccountError(validationError));
      return;
    }

    emit(CreateAccountLoading());

    //Firebase Authentication API çağrısı
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(CreateAccountSuccess("Registration successful! Welcome."));
    } on FirebaseAuthException catch (e) {
      final errorMessage = ErrorHandler.getFirebaseAuthErrorMessage(e.code);
      emit(CreateAccountError(errorMessage));
    } catch (e) {
      emit(CreateAccountError("An unexpected error occurred"));
    }
  }

  String? _validateInputs(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return "Please fill in all fields.";
    }

    if (!Validators.isValidEmail(email)) {
      return "Please enter a valid email address.";
    }

    if (!Validators.isValidPassword(password)) {
      return "Password must be at least 6 characters.";
    }

    return null;
  }
}

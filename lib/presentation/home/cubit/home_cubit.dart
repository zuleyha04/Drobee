import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseAuth _firebaseAuth;

  HomeCubit(this._firebaseAuth)
    : super(HomeState(email: _firebaseAuth.currentUser?.email));

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _firebaseAuth.signOut();
      emit(HomeState(email: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

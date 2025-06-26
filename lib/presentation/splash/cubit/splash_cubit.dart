import 'package:drobee/presentation/splash/cubit/splash_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted() async {
    await Future.delayed(Duration(seconds: 3));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}

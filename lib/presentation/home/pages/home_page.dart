import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/common/widget/navigationBar/main_navigation_wrapper.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/presentation/home/widgets/float_act_button.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(FirebaseAuth.instance),
      child: WillPopScope(
        onWillPop: () async => false,
        child: MainNavigationWrapper(
          homePageContent: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Ana Sayfa"),
              actions: [
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    //TODO: Logout butonu taşınacak
                    return IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await context.read<HomeCubit>().logout();
                        if (context.read<HomeCubit>().state.email == null) {
                          AppNavigator.pushReplacement(
                            context,
                            const OnBoardingPage(initialPage: 3),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            body: Center(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.email == null) {
                    return const Text('Kullanıcı bilgisi bulunamadı');
                  }
                  if (state.error != null) {
                    return Text('Hata: ${state.error}');
                  }
                  return Text(
                    "Hoşgeldin ! ${state.email}",
                    style: const TextStyle(fontSize: 15),
                  );
                },
              ),
            ),
            floatingActionButton: const AddFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }
}

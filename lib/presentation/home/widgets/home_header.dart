import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Closet",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.isLoading) {}
              //TODO:logout butonu son sayfaya taşınacak
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
    );
  }
}

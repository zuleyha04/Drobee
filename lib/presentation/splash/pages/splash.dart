import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/presentation/home/pages/home_page.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';
import 'package:drobee/presentation/splash/cubit/splash_cubit.dart';
import 'package:drobee/presentation/splash/cubit/splash_state.dart';
import 'package:drobee/presentation/splash/widgets/bottom_text.dart';
import 'package:drobee/presentation/splash/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          AppNavigator.pushReplacement(context, OnBoardingPage());
        }
        // FIXME: Authenticated state
        else {
          AppNavigator.pushReplacement(context, HomePage());
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Stack(
            children: [
              Center(child: LogoWidget(logoPath: 'assets/images/drobee.png')),
              const BottomTextWidget(text: 'Drobee'),
            ],
          ),
        ),
      ),
    );
  }
}

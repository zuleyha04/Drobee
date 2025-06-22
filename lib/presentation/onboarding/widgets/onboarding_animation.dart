import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBoardingAnimation extends StatelessWidget {
  final String animationPath;

  const OnBoardingAnimation({super.key, required this.animationPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 200,
      child: Center(
        child: Lottie.asset(
          animationPath,
          width: 400,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

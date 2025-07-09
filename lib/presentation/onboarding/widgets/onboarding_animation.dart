import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingAnimation extends StatelessWidget {
  final String animationPath;

  const OnBoardingAnimation({super.key, required this.animationPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.w,
      height: 200.h,
      child: Center(
        child: Lottie.asset(
          animationPath,
          width: 400.w,
          height: 200.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

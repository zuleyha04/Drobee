import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Eklendi

class LogoWidget extends StatelessWidget {
  final String logoPath;
  final double width;
  final double height;
  final double bottomPadding;

  const LogoWidget({
    super.key,
    required this.logoPath,
    this.width = 250,
    this.height = 250,
    this.bottomPadding = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: Image.asset(
        logoPath,
        width: width.w,
        height: height.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double bottomPadding;

  const BottomTextWidget({
    super.key,
    required this.text,
    this.style,
    this.bottomPadding = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPadding.h,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          text,
          style:
              style ??
              TextStyle(
                color: Colors.white,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

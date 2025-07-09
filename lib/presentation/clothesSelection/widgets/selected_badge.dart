import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedBadge extends StatelessWidget {
  const SelectedBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.h,
      right: 8.w,
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: 16.w),
      ),
    );
  }
}

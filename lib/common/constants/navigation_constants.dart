import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationConstants {
  static const List<IconData> icons = [
    Icons.checkroom,
    Icons.auto_fix_high,
    Icons.wb_cloudy,
    Icons.settings,
  ];

  static const List<String> labels = ['Closet', 'Style', 'Weather', 'Settings'];

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  // Navigation Bar Styling
  static double get navigationBarHeight => 80.0.h;
  static double get navigationBarMargin => 16.0.w;
  static double get navigationBarRadius => 25.0.r;
  static double get itemHeight => 60.0.h;
  static double get itemMarginHorizontal => 8.0.w;
  static double get itemMarginVertical => 10.0.h;
  static double get itemRadius => 20.0.r;
  static double get iconContainerRadius => 12.0.r;
  static double get iconPadding => 6.0.w;
  static double get selectedIconSize => 24.0.sp;
  static double get unselectedIconSize => 22.0.sp;
  static double get selectedFontSize => 12.0.sp;
  static double get unselectedFontSize => 11.0.sp;
  static double get spaceBetweenIconAndText => 4.0.h;
}

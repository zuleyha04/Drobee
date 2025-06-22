import 'package:flutter/material.dart';

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
  static const double navigationBarHeight = 80.0;
  static const double navigationBarMargin = 16.0;
  static const double navigationBarRadius = 25.0;
  static const double itemHeight = 60.0;
  static const double itemMarginHorizontal = 8.0;
  static const double itemMarginVertical = 10.0;
  static const double itemRadius = 20.0;
  static const double iconContainerRadius = 12.0;
  static const double iconPadding = 6.0;
  static const double selectedIconSize = 24.0;
  static const double unselectedIconSize = 22.0;
  static const double selectedFontSize = 12.0;
  static const double unselectedFontSize = 11.0;
  static const double spaceBetweenIconAndText = 4.0;
}

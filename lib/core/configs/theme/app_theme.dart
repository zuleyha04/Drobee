import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light, // Light tema olarak değiştirildi
    fontFamily: 'CircularStd',
  );
}

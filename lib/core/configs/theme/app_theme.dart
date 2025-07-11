import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light, // Light tema olarak değiştirildi
    fontFamily: 'CircularStd',

    // ColorScheme tanımı
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      onPrimary: AppColors.textWhite,
      onSecondary: AppColors.textWhite,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),

    // Input decoration teması
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(
        color: AppColors.textHint,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.inputBorderFocused,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );
}

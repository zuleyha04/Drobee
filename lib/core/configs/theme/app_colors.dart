import 'package:flutter/material.dart';

class AppColors {
  // Ana renkler
  static const Color primary = Color.fromARGB(255, 95, 60, 191);
  static const Color secondary = Color(0xFFE91E63);

  // Arka plan renkleri
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;

  // Metin renkleri
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color.fromARGB(255, 129, 135, 148);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textWhite = Colors.white;

  // Border ve outline renkleri
  static const Color inputBorder = Color(0xFFE5E7EB);
  static const Color inputBorderFocused = primary;

  // Gradient tanımı
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFF5F3CBF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static Color buttonEisabledBackColor = Color(0xFFF5F5F5);
  static const Color disabledForegColor = Color(0xFF757575);
}

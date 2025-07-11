import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Başlık stilleri
  static TextStyle get mainTitleStyle => GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
  );

  static TextStyle get descriptionTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textSecondary,
    ),
  );

  static TextStyle get thinDescriptionTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textSecondary,
      letterSpacing: 1,
    ),
  );

  static TextStyle get whiteButtonText => GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textWhite,
      letterSpacing: 1,
    ),
  );

  static TextStyle get blackButtonText => GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      letterSpacing: 1,
    ),
  );

  static TextStyle get thinBlackText => GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
  );

  static TextStyle get boldPrimaryText => GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  );
}

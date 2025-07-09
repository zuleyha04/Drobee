import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';

class GoogleLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GoogleLoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon:
            isLoading
                ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
                : Icon(
                  FontAwesomeIcons.google,
                  size: 20.sp,
                  color: AppColors.primary,
                ),
        label: const Text('Continue with Google'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.primary),
          padding: EdgeInsets.symmetric(vertical: 18.h),
          elevation: 2,
          textStyle: AppTextStyles.blackButtonText,
          disabledBackgroundColor: AppColors.buttonEisabledBackColor,
          disabledForegroundColor: AppColors.disabledForegColor,
        ),
      ),
    );
  }
}

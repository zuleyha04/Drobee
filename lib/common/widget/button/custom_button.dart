import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? content;

  const CustomButton({
    super.key,
    this.text = '',
    required this.onTap,
    this.width,
    this.height,
    this.padding,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
      child: SizedBox(
        width: (width ?? 350.w),
        height: (height ?? 56.h),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Center(
              child:
                  content ?? Text(text, style: AppTextStyles.whiteButtonText),
            ),
          ),
        ),
      ),
    );
  }
}

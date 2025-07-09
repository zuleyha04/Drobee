import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5),
        backgroundColor: AppColors.inputBorder,
      ),
      onPressed: onPressed,
      child: Text(
        'Skip',
        style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
      ),
    );
  }
}

import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
    this.width = 350,
    this.height = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 56,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
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

import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextWidget extends StatelessWidget {
  final String text;
  final VoidCallback onLoginTap;

  const LoginTextWidget({
    super.key,
    required this.onLoginTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: AppTextStyles.thinBlackText),
          GestureDetector(
            onTap: onLoginTap,
            child: Text('Log In', style: AppTextStyles.boldPrimaryText),
          ),
        ],
      ),
    );
  }
}

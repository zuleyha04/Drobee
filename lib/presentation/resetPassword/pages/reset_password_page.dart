import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/presentation/login/pages/login_page.dart';
import 'package:drobee/presentation/resetPassword/widgets/reset_password_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 28.sp),
          onPressed:
              () => AppNavigator.pushReplacement(context, const LoginPage()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ResetPasswordForm(
          title: 'Reset Password',
          description:
              'Enter the email address associated with '
              'your account and we\'ll send you an email'
              ' to reset your password.',
        ),
      ),
    );
  }
}

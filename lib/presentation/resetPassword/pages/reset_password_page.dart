import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/presentation/resetPassword/widgets/reset_password_form_widgets.dart';
import 'package:flutter/material.dart';

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
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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

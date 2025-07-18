import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/presentation/createAccount/pages/create_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinueWithEmailButton extends StatelessWidget {
  const ContinueWithEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        AppNavigator.pushReplacement(context, CreateAccountPage());
      },
      text: 'Continue with Email',
      padding: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }
}

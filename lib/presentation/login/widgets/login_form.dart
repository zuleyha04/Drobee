import 'package:drobee/common/widget/textField/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          hintText: 'Enter Email Address',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSubmitted: () {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          hintText: 'Enter Your Password',
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }
}

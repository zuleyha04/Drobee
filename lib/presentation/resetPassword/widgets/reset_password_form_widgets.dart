import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/common/widget/textField/custom_text_field.dart';
import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drobee/core/utils/app_flushbar.dart';

class ResetPasswordForm extends StatefulWidget {
  final String title;
  final String description;

  const ResetPasswordForm({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.title, style: AppTextStyles.mainTitleStyle),
        const SizedBox(height: 16),
        Text(widget.description, style: AppTextStyles.descriptionTextStyle),
        const SizedBox(height: 32),
        CustomTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          hintText: 'Enter Email Address',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: () => FocusScope.of(context).unfocus(),
        ),
        const Spacer(),
        CustomButton(
          text: 'Reset Password',
          onTap: () async {
            final email = emailController.text.trim();

            if (email.isEmpty) {
              AppFlushbar.showError(context, 'Please enter your email address');
              return;
            }

            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

              emailController.clear();
              AppFlushbar.showSuccess(context, 'Password reset email sent!');
            } on FirebaseAuthException catch (e) {
              String message = 'An error occurred';
              if (e.code == 'user-not-found') {
                message = 'No user found with this email.';
              } else if (e.code == 'invalid-email') {
                message = 'The email address is not valid.';
              }

              AppFlushbar.showError(context, message);
            }
          },
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

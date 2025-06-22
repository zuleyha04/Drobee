import 'package:drobee/common/widget/textField/custom_text_field.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: 'Enter Your Password',
      obscureText: true,
      textInputAction: TextInputAction.done,
      onSubmitted: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

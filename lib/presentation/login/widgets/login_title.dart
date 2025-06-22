import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Login to your\naccount !',
      style: AppTextStyles.mainTitleStyle,
    );
  }
}

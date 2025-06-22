import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Creating your account !', style: AppTextStyles.mainTitleStyle);
  }
}

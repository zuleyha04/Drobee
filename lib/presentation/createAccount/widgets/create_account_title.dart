import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

class CreateAccountTitle extends StatelessWidget {
  final String text;

  const CreateAccountTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.mainTitleStyle);
  }
}

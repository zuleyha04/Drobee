import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;

  const CreateAccountButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CustomButton(
        onTap: isLoading ? () {} : onPressed,
        text: title,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
      ),
    );
  }
}

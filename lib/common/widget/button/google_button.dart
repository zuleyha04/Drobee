import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';

class GoogleLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GoogleLoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon:
            isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
                : const Icon(
                  FontAwesomeIcons.google,
                  size: 20,
                  color: AppColors.primary,
                ),
        label: const Text('Continue with Google'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 2,
          textStyle: AppTextStyles.blackButtonText,
          disabledBackgroundColor: AppColors.buttonEisabledBackColor,
          disabledForegroundColor: AppColors.disabledForegColor,
        ),
      ),
    );
  }
}

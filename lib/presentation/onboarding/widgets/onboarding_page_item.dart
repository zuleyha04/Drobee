import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/common/widget/button/skip_button.dart';
import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/presentation/onboarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'login_text_widget.dart';
import 'onboarding_animation.dart';

class OnBoardingPageItem extends StatelessWidget {
  final OnBoardingModel item;
  final int index;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const OnBoardingPageItem({
    super.key,
    required this.item,
    required this.index,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (currentPage != totalPages - 1)
                      SkipButton(onPressed: onSkip),
                  ],
                ),
                const SizedBox(height: 80),
                OnBoardingAnimation(animationPath: item.animation),
                const SizedBox(height: 90),
                if (index == totalPages - 1) const SizedBox(height: 40),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mainTitleStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  item.subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.descriptionTextStyle,
                ),
                if (index == totalPages - 1) ...[
                  const Expanded(child: SizedBox()),
                  CustomButton(text: 'Get Started', onTap: onSignUp),
                  LoginTextWidget(
                    onLoginTap: onLogin,
                    text: 'Already have an account ? ',
                  ),
                ] else ...[
                  const SizedBox(height: 100),
                  CustomButton(text: 'Next', onTap: onNext),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/common/widget/button/skip_button.dart';
import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/presentation/onboarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      decoration: const BoxDecoration(color: AppColors.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                /// Skip butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (currentPage != totalPages - 1)
                      SkipButton(onPressed: onSkip),
                  ],
                ),

                SizedBox(height: 30.h),

                /// Animasyon
                Expanded(
                  flex: 4,
                  child: OnBoardingAnimation(animationPath: item.animation),
                ),

                SizedBox(height: 24.h),

                /// Başlık
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mainTitleStyle,
                ),

                SizedBox(height: 10.h),

                /// Alt başlık
                Text(
                  item.subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.descriptionTextStyle,
                ),

                SizedBox(height: 30.h),

                /// Butonlar
                if (index == totalPages - 1) ...[
                  CustomButton(text: 'Get Started', onTap: onSignUp),
                  LoginTextWidget(
                    onLoginTap: onLogin,
                    text: 'Already have an account ? ',
                  ),
                ] else ...[
                  CustomButton(text: 'Next', onTap: onNext),
                ],
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

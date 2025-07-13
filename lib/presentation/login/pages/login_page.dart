import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/common/widget/button/google_button.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/presentation/home/pages/home_page.dart';
import 'package:drobee/presentation/login/widgets/reset_password_widget.dart';
import 'package:drobee/presentation/login/widgets/login_divider_widget.dart';
import 'package:drobee/presentation/login/widgets/login_form.dart';
import 'package:drobee/presentation/login/widgets/login_title.dart';
import 'package:drobee/presentation/login/cubit/login_cubit.dart';
import 'package:drobee/presentation/login/cubit/login_state.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 28.sp),
            onPressed:
                () => AppNavigator.pushReplacement(
                  context,
                  OnBoardingPage(initialPage: 3),
                ),
          ),
        ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => false,
              );
            } else if (state is LoginFailure) {
              AppFlushbar.showError(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is LoginLoading || state is LoginSuccess) {
              return const Center(child: CircularProgressIndicator());
            }
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      const LoginTitle(),
                      SizedBox(height: 30.h),
                      LoginForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        emailFocusNode: emailFocusNode,
                        passwordFocusNode: passwordFocusNode,
                      ),
                      SizedBox(height: 24.h),
                      CustomButton(
                        text: 'Login',
                        onTap: () {
                          final String email = emailController.text.trim();
                          final String password = passwordController.text;

                          context.read<LoginCubit>().login(email, password);
                        },
                      ),
                      SizedBox(height: 32.h),
                      const ResetPasswordWidget(
                        text1: 'Forgot Password? ',
                        text2: 'Reset',
                      ),
                      SizedBox(height: 32.h),
                      const LoginDivider(),
                      SizedBox(height: 32.h),
                      GoogleLoginButton(
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          context.read<LoginCubit>().signInWithGoogle();
                        },
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

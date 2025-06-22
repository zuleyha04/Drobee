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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              AppNavigator.pushReplacement(context, HomePage());
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const LoginTitle(),
                      const SizedBox(height: 30),
                      LoginForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        emailFocusNode: emailFocusNode,
                        passwordFocusNode: passwordFocusNode,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Login',
                        onTap: () {
                          final String email = emailController.text.trim();
                          final String password = passwordController.text;

                          context.read<LoginCubit>().login(email, password);
                        },
                      ),
                      const SizedBox(height: 32),
                      const ResetPasswordWidget(
                        text1: 'Forgot Password? ',
                        text2: 'Reset',
                      ),
                      const SizedBox(height: 32),
                      const LoginDivider(),
                      const SizedBox(height: 32),
                      GoogleLoginButton(
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          context.read<LoginCubit>().signInWithGoogle();
                        },
                      ),
                      const SizedBox(height: 12),
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

import 'package:drobee/common/widget/button/google_button.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/presentation/signup/cubit/sign_up_cubit.dart';
import 'package:drobee/presentation/signup/cubit/sign_up_state.dart';
import 'package:drobee/presentation/signup/widgets/sign_up_email_button.dart';
import 'package:drobee/presentation/signup/widgets/sign_up_or_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/sign_up_title.dart';
import '../../home/pages/home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocProvider(
          create: (_) => SignupCubit(),
          child: BlocListener<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state is SignupSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                });
              } else if (state is SignupFailure) {
                AppFlushbar.showError(context, state.errorMessage);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const SignUpTitle(),
                const SizedBox(height: 40),
                const ContinueWithEmailButton(),
                const SizedBox(height: 32),
                const OrDivider(),
                const SizedBox(height: 32),

                /// Google butonu bloc ile kontrol ediliyor
                BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    final isLoading = state is SignupLoading;
                    return GoogleLoginButton(
                      isLoading: isLoading,
                      onPressed: () {
                        context.read<SignupCubit>().signUpWithGoogle();
                      },
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/presentation/createAccount/cubit/create_account_cubit.dart';
import 'package:drobee/presentation/createAccount/cubit/create_account_state.dart';
import 'package:drobee/presentation/createAccount/widgets/create_account_button.dart';
import 'package:drobee/presentation/createAccount/widgets/create_account_title.dart';
import 'package:drobee/presentation/home/pages/home_page.dart';
import 'package:drobee/presentation/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAccountCubit(),
      child: const CreateAccountView(),
    );
  }
}

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        if (state is CreateAccountSuccess) {
          _navigateToHomePage();
        } else if (state is CreateAccountError) {
          AppFlushbar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is CreateAccountLoading || state is CreateAccountSuccess) {
          return const Center(child: CircularProgressIndicator());
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const CreateAccountTitle(text: 'Creating your account !'),
                  const SizedBox(height: 30),
                  _buildLoginForm(),
                  const SizedBox(height: 32),
                  _buildCreateAccountButton(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return LoginForm(
      emailController: emailController,
      passwordController: passwordController,
      emailFocusNode: emailFocusNode,
      passwordFocusNode: passwordFocusNode,
    );
  }

  Widget _buildCreateAccountButton(CreateAccountState state) {
    final isLoading = state is CreateAccountLoading;

    return CreateAccountButton(
      title: 'Create Account',
      isLoading: isLoading,
      onPressed: _handleCreateAccount,
    );
  }

  void _handleCreateAccount() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    context.read<CreateAccountCubit>().createAccount(email, password);
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(Duration.zero);

    if (mounted) {
      AppNavigator.pushReplacement(context, HomePage());
    }
  }
}

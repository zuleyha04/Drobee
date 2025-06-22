import 'package:drobee/presentation/login/pages/login_page.dart';
import 'package:drobee/presentation/signup/pages/sign_up_page.dart';
import 'package:drobee/presentation/onboarding/model/onboarding_model.dart';
import 'package:drobee/presentation/onboarding/widgets/onboarding_page_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  final int initialPage;

  const OnBoardingPage({super.key, this.initialPage = 0});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController pageController;
  int currentPage = 0;

  final List<OnBoardingModel> list = [
    OnBoardingModel(
      title: 'Digitalize Your Wardrobe!',
      subTitle:
          'Easily photograph and organize your clothes into categories for instant\naccess anytime.',
      animation: 'assets/lottie/animation1.json',
    ),
    OnBoardingModel(
      title: 'Create Stylish Outfits Easily',
      subTitle:
          'Mix and match your clothes to create custom outfits that reflect your unique fashion sense.',
      animation: 'assets/lottie/animation2.json',
    ),
    OnBoardingModel(
      title: 'Dress Smart for the Weather',
      subTitle:
          'Get daily outfit ideas tailored to the current weather and step out in\nstyle rain or shine.',
      animation: 'assets/lottie/animation3.json',
    ),
    OnBoardingModel(
      title: 'Welcome to Drobee!',
      subTitle:
          'Ready to explore your style with us?\nLog in or sign up to get started.',
      animation: 'assets/lottie/animation4.json',
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    currentPage = widget.initialPage;
  }

  Future<void> _handleNextPage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _handleSkip() {
    pageController.animateToPage(
      list.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void _handleSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: list.length,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      itemBuilder: (context, index) {
        return OnBoardingPageItem(
          item: list[index],
          index: index,
          currentPage: currentPage,
          totalPages: list.length,
          onNext: _handleNextPage,
          onSkip: _handleSkip,
          onLogin: _handleLogin,
          onSignUp: _handleSignUp,
        );
      },
    );
  }
}

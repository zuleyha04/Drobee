import 'package:drobee/common/constants/navigation_constants.dart';
import 'package:drobee/presentation/settingPage/setting_page.dart';
import 'package:drobee/presentation/stylePage/style_page.dart';
import 'package:drobee/presentation/weather/weather_page.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class MainNavigationWrapper extends StatefulWidget {
  final Widget homePageContent;

  const MainNavigationWrapper({super.key, required this.homePageContent});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
    _initializeAnimations();
  }

  void _initializePages() {
    _pages = [
      widget.homePageContent,
      const StylePage(),
      const WeatherPage(),
      const SettingPage(),
    ];
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: NavigationConstants.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: NavigationConstants.animationCurve,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      _animationController.reset();
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
        animation: _animation,
      ),
    );
  }
}

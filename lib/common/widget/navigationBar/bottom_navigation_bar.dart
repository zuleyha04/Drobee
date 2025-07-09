import 'package:drobee/common/constants/navigation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navigation_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;
  final Animation<double> animation;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: NavigationConstants.navigationBarHeight,
      margin: EdgeInsets.all(NavigationConstants.navigationBarMargin),
      decoration: _buildNavigationBarDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildNavigationItems(),
      ),
    );
  }

  BoxDecoration _buildNavigationBarDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        NavigationConstants.navigationBarRadius,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20.r,
          offset: Offset(0, 5.h),
        ),
      ],
    );
  }

  List<Widget> _buildNavigationItems() {
    return List.generate(
      NavigationConstants.icons.length,
      (index) => NavigationItem(
        icon: NavigationConstants.icons[index],
        label: NavigationConstants.labels[index],
        isSelected: index == currentIndex,
        onTap: () => onItemTapped(index),
        animation: animation,
      ),
    );
  }
}

import 'package:drobee/common/constants/navigation_constants.dart';
import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Animation<double> animation;

  const NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => _buildItemContainer(theme),
        ),
      ),
    );
  }

  Widget _buildItemContainer(ThemeData theme) {
    return Container(
      height: NavigationConstants.itemHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: NavigationConstants.itemMarginHorizontal,
        vertical: NavigationConstants.itemMarginVertical,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(NavigationConstants.itemRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconContainer(theme),
          const SizedBox(height: NavigationConstants.spaceBetweenIconAndText),
          _buildLabel(theme),
        ],
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme) {
    return AnimatedContainer(
      duration: NavigationConstants.animationDuration,
      curve: NavigationConstants.animationCurve,
      padding: const EdgeInsets.all(NavigationConstants.iconPadding),
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(
          NavigationConstants.iconContainerRadius,
        ),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey.shade600,
        size:
            isSelected
                ? NavigationConstants.selectedIconSize
                : NavigationConstants.unselectedIconSize,
      ),
    );
  }

  Widget _buildLabel(ThemeData theme) {
    return AnimatedDefaultTextStyle(
      duration: NavigationConstants.animationDuration,
      style: TextStyle(
        color: isSelected ? theme.primaryColor : Colors.grey.shade600,
        fontSize:
            isSelected
                ? NavigationConstants.selectedFontSize
                : NavigationConstants.unselectedFontSize,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      child: Text(label),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationConstants {
  static const List<IconData> icons = [
    Icons.checkroom,
    Icons.auto_fix_high,
    Icons.wb_cloudy,
    Icons.settings,
  ];

  static const List<String> labels = ['Closet', 'Style', 'Weather', 'Settings'];

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  // Ekran genişliğine göre dinamik boyutlar
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;

  // Minimum ve maksimum değerler ile güvenli boyutlar
  static double get navigationBarHeight => _clampValue(70.0.h, 60.0, 90.0);
  static double get navigationBarMargin => _clampValue(12.0.w, 8.0, 20.0);
  static double get navigationBarRadius => _clampValue(20.0.r, 15.0, 30.0);

  // Item boyutları - daha küçük değerler
  static double get itemHeight => _clampValue(50.0.h, 45.0, 65.0);
  static double get itemMarginHorizontal => _clampValue(4.0.w, 2.0, 8.0);
  static double get itemMarginVertical => _clampValue(8.0.h, 6.0, 12.0);
  static double get itemRadius => _clampValue(15.0.r, 12.0, 20.0);
  static double get iconContainerRadius => _clampValue(10.0.r, 8.0, 15.0);
  static double get iconPadding => _clampValue(4.0.w, 3.0, 8.0);

  // Icon boyutları - daha küçük
  static double get selectedIconSize => _clampValue(20.0.sp, 18.0, 26.0);
  static double get unselectedIconSize => _clampValue(18.0.sp, 16.0, 22.0);

  // Font boyutları - daha küçük
  static double get selectedFontSize => _clampValue(10.0.sp, 9.0, 13.0);
  static double get unselectedFontSize => _clampValue(9.0.sp, 8.0, 11.0);

  static double get spaceBetweenIconAndText => _clampValue(2.0.h, 1.0, 4.0);

  // Çok küçük ekranlar için özel değerler
  static bool get isVerySmallScreen => screenWidth < 360 || screenHeight < 640;

  // Değeri minimum ve maksimum arasında sınırla
  static double _clampValue(double value, double min, double max) {
    return value.clamp(min, max);
  }

  // Adaptif boyutlar - ekran boyutuna göre
  static double get adaptiveNavigationBarHeight {
    if (isVerySmallScreen) {
      return 55.0;
    }
    return navigationBarHeight;
  }

  static double get adaptiveItemHeight {
    if (isVerySmallScreen) {
      return 40.0;
    }
    return itemHeight;
  }

  static double get adaptiveSelectedIconSize {
    if (isVerySmallScreen) {
      return 16.0;
    }
    return selectedIconSize;
  }

  static double get adaptiveUnselectedIconSize {
    if (isVerySmallScreen) {
      return 14.0;
    }
    return unselectedIconSize;
  }

  static double get adaptiveSelectedFontSize {
    if (isVerySmallScreen) {
      return 8.0;
    }
    return selectedFontSize;
  }

  static double get adaptiveUnselectedFontSize {
    if (isVerySmallScreen) {
      return 7.0;
    }
    return unselectedFontSize;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedOverlay extends StatelessWidget {
  const SelectedOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
    );
  }
}

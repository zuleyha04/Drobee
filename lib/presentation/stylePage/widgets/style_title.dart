import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyleTitle extends StatelessWidget {
  final String title;

  const StyleTitle({super.key, this.title = 'Style'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: PageTitle('Style'),
        ),
      ],
    );
  }
}

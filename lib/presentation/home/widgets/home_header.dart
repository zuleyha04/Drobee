import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PageTitle('Closet'),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:flutter/material.dart';

class StyleTitle extends StatelessWidget {
  final String title;

  const StyleTitle({Key? key, this.title = 'Style'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [PageTitle('Style')],
        ),
      ),
    );
  }
}

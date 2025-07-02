import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:flutter/material.dart';

class StylePage extends StatelessWidget {
  const StylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageTitle('Style'),
          SizedBox(height: 20),
          Text(
            "Bu style sayfasıdır. Burada stil önerilerinizi görebilirsiniz.",
          ),
        ],
      ),
    );
  }
}

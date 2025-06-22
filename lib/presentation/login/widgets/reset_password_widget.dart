import 'package:drobee/core/configs/textStyles/text_styles.dart';
import 'package:drobee/presentation/resetPassword/pages/reset_password_page.dart';
import 'package:flutter/material.dart';

class ResetPasswordWidget extends StatelessWidget {
  final String text1, text2;

  const ResetPasswordWidget({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: text1,
          style: AppTextStyles.thinDescriptionTextStyle,
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                    ),
                  );
                },
                child: Text(text2, style: AppTextStyles.boldPrimaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

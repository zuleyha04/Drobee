import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String logoPath;
  final double width;
  final double height;
  final double bottomPadding;

  const LogoWidget({
    super.key,
    required this.logoPath,
    this.width = 250,
    this.height = 300,
    this.bottomPadding = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Image.asset(
        logoPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

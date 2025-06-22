import 'package:flutter/material.dart';

class BottomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double bottomPadding;

  const BottomTextWidget({
    super.key,
    required this.text,
    this.style,
    this.bottomPadding = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPadding,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          text,
          style:
              style ??
              const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

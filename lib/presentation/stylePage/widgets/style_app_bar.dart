import 'package:flutter/material.dart';

class StyleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StyleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Style',
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

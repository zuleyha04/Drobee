import 'package:flutter/material.dart';

class StyleErrorState extends StatelessWidget {
  final String message;

  const StyleErrorState({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: TextStyle(fontSize: 16, color: Colors.red[700]),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmptyImagePlaceholder extends StatelessWidget {
  const EmptyImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Images Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add new images',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

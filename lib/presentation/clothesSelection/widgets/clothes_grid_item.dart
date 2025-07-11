import 'package:flutter/material.dart';

import 'clothes_image_container.dart';
import 'selected_overlay.dart';
import 'selected_badge.dart';

class ClothesGridItem extends StatelessWidget {
  final dynamic image;
  final bool isSelected;
  final VoidCallback onTap;

  const ClothesGridItem({
    super.key,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClothesImageContainer(
            imageUrl: image.imageUrl,
            isSelected: isSelected,
          ),
          if (isSelected) const SelectedOverlay(),
          if (isSelected) const SelectedBadge(),
        ],
      ),
    );
  }
}

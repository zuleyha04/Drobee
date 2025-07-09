import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'selection_header.dart';
import 'clothes_grid_item.dart';

class ClothesGridView extends StatelessWidget {
  final List<dynamic> images;
  final List<String> selectedImageIds;
  final Function(String) onImageTap;

  const ClothesGridView({
    Key? key,
    required this.images,
    required this.selectedImageIds,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionHeader(selectedCount: selectedImageIds.length),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              final isSelected = selectedImageIds.contains(image.id);

              return ClothesGridItem(
                image: image,
                isSelected: isSelected,
                onTap: () => onImageTap(image.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

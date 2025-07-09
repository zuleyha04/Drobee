import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClothesImageContainer extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;

  const ClothesImageContainer({
    Key? key,
    required this.imageUrl,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border:
            isSelected
                ? Border.all(color: Theme.of(context).primaryColor, width: 3.w)
                : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey,
                  size: 32.w,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

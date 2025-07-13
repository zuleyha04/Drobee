import 'package:flutter/material.dart';
import 'package:drobee/presentation/home/models/user_image_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCard extends StatelessWidget {
  final UserImageModel image;
  final bool showDeleteButton;

  const ImageCard({
    super.key,
    required this.image,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 32.sp,
                    ),
                  );
                },
              ),
            ),
            if (showDeleteButton)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeCubit>().deleteImage(image.id);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16.r,
                    child: Icon(Icons.close, size: 18.sp, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

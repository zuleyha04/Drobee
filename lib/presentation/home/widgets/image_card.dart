import 'package:flutter/material.dart';
import 'package:drobee/presentation/home/models/user_image_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';

class ImageCard extends StatelessWidget {
  final UserImageModel image;

  const ImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  context.read<HomeCubit>().deleteImage(image.id);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 16,
                  child: Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

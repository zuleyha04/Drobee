import 'package:drobee/presentation/home/widgets/empty_image_placeholder.dart';
import 'package:drobee/presentation/home/widgets/image_card.dart';
import 'package:flutter/material.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';

class ImageGrid extends StatelessWidget {
  final HomeState state;

  const ImageGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.userImages.isEmpty) return const EmptyImagePlaceholder();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.userImages.length,
      itemBuilder: (context, index) {
        final image = state.userImages[index];
        return ImageCard(image: image);
      },
    );
  }
}

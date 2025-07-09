import 'package:drobee/presentation/clothesSelection/widgets/clothes_grid_view.dart';
import 'package:drobee/presentation/clothesSelection/widgets/empty_clothes_widget.dart';
import 'package:drobee/presentation/clothesSelection/widgets/loading_widget.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';

class ClothesSelectionBody extends StatelessWidget {
  final HomeState state;
  final List<String> selectedImageIds;
  final Function(String) onImageTap;

  const ClothesSelectionBody({
    Key? key,
    required this.state,
    required this.selectedImageIds,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.email == null) {
      return const LoadingWidget();
    }

    if (state.error != null) {
      return ErrorWidget(state.error!);
    }

    if (state.userImages.isEmpty) {
      return const EmptyClothesWidget();
    }

    return ClothesGridView(
      images: state.userImages,
      selectedImageIds: selectedImageIds,
      onImageTap: onImageTap,
    );
  }
}

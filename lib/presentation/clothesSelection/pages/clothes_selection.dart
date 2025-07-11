import 'package:drobee/presentation/clothesSelection/widgets/clothes_app_bar.dart';
import 'package:drobee/presentation/clothesSelection/widgets/clothes_selection_body.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClothesSelectionPage extends StatefulWidget {
  const ClothesSelectionPage({super.key});

  @override
  State<ClothesSelectionPage> createState() => _ClothesSelectionPageState();
}

class _ClothesSelectionPageState extends State<ClothesSelectionPage> {
  List<String> selectedImageIds = [];

  void _onImageTap(String imageId) {
    setState(() {
      if (selectedImageIds.contains(imageId)) {
        selectedImageIds.remove(imageId);
      } else {
        selectedImageIds.add(imageId);
      }
    });
  }

  void _onDonePressed(BuildContext context, HomeState state) {
    final selectedImages =
        state.userImages
            .where((image) => selectedImageIds.contains(image.id))
            .map((img) => SelectedImageData(id: img.id, imageUrl: img.imageUrl))
            .toList();

    Navigator.pop(
      context,
      ClothesSelectionResult(selectedImages: selectedImages),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(FirebaseAuth.instance),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              selectedCount: selectedImageIds.length,
              onDonePressed: () => _onDonePressed(context, state),
            ),
            body: ClothesSelectionBody(
              state: state,
              selectedImageIds: selectedImageIds,
              onImageTap: _onImageTap,
            ),
          );
        },
      ),
    );
  }
}

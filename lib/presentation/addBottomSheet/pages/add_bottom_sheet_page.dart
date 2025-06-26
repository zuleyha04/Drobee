import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:drobee/presentation/addBottomSheet/pages/photo_picker_actions.dart';
import 'package:drobee/presentation/addBottomSheet/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/addBottomSheet/widgets/weather_chips.dart';

class PhotoPickerBottomSheet extends StatelessWidget {
  const PhotoPickerBottomSheet({super.key});

  static const List<String> _weatherOptions = [
    "Sunny",
    "Cloudy",
    "Rainy",
    "Snowy",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoPickerCubit(),
      child: BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
        builder: (context, state) {
          // Debug print: BlocBuilder rebuild kontrolü
          print('BlocBuilder rebuild, displayImage: ${state.displayImage}');

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildPhotoArea(state, context),
                        const SizedBox(height: 16),
                        const PhotoPickerActions(),
                        const SizedBox(height: 16),
                        const WeatherChips(options: _weatherOptions),
                        const SizedBox(height: 20),
                        const SaveButton(),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Add Your Items",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea(PhotoPickerState state, BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: _buildPhotoContent(state, context)),
      ),
    );
  }

  Widget _buildPhotoContent(PhotoPickerState state, BuildContext context) {
    // Loading durumları
    if (state.isLoading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Resim seçiliyor...'),
        ],
      );
    }

    if (state.isProcessing) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Arka plan siliniyor...'),
        ],
      );
    }

    // Resim gösterimi (processedImage öncelikli, sonra selectedImage)
    if (state.displayImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              state.displayImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Sil butonu
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                print("Remove tapped");
                context.read<PhotoPickerCubit>().removeImage();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    }

    // Boş durum
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade500),
        const SizedBox(height: 10),
        Text(
          "Add Photo",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

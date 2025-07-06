import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectedImageData {
  final String id;
  final String imageUrl;

  SelectedImageData({required this.id, required this.imageUrl});
}

class ClothesSelectionResult {
  final List<SelectedImageData> selectedImages;

  ClothesSelectionResult({required this.selectedImages});
}

class ClothesSelectionPage extends StatefulWidget {
  const ClothesSelectionPage({Key? key}) : super(key: key);

  @override
  State<ClothesSelectionPage> createState() => _ClothesSelectionPageState();
}

class _ClothesSelectionPageState extends State<ClothesSelectionPage> {
  List<String> selectedImageIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(FirebaseAuth.instance),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final images = state.userImages;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Select Clothes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: [
                if (selectedImageIds.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      final selectedImages =
                          state.userImages
                              .where(
                                (image) => selectedImageIds.contains(image.id),
                              )
                              .map(
                                (img) => SelectedImageData(
                                  id: img.id,
                                  imageUrl: img.imageUrl,
                                ),
                              )
                              .toList();

                      Navigator.pop(
                        context,
                        ClothesSelectionResult(selectedImages: selectedImages),
                      );
                    },

                    child: Text(
                      'Done (${selectedImageIds.length})',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (state.email == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hata: ${state.error}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (images.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Henüz kıyafet fotoğrafınız yok',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Önce ana sayfadan kıyafet fotoğrafları ekleyin',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Text(
                        selectedImageIds.isEmpty
                            ? 'Kıyafetlerinizi seçin'
                            : '${selectedImageIds.length} kıyafet seçildi',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1,
                            ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final image = images[index];
                          final isSelected = selectedImageIds.contains(
                            image.id,
                          );

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedImageIds.remove(image.id);
                                } else {
                                  selectedImageIds.add(image.id);
                                }
                              });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        isSelected
                                            ? Border.all(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                              width: 3,
                                            )
                                            : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      image.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[100],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.grey,
                                              size: 32,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.3),
                                    ),
                                  ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

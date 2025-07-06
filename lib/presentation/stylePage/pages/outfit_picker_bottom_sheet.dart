import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/presentation/stylePage/pages/image_selection.dart';
import 'package:flutter/material.dart';

class OutfitPickerBottomSheet extends StatefulWidget {
  const OutfitPickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<OutfitPickerBottomSheet> createState() =>
      _OutfitPickerBottomSheetState();
}

class _OutfitPickerBottomSheetState extends State<OutfitPickerBottomSheet> {
  List<DraggableImageItem> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Your Items',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 📸 Photo Upload Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child:
                      selectedImages.isEmpty
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                          : Stack(
                            children: [
                              // Seçilen fotoğrafları göster
                              ...selectedImages.map((imageItem) {
                                return Positioned(
                                  left: imageItem.position.dx,
                                  top: imageItem.position.dy,
                                  child: GestureDetector(
                                    onPanUpdate: (details) {
                                      setState(() {
                                        final newPosition = Offset(
                                          imageItem.position.dx +
                                              details.delta.dx,
                                          imageItem.position.dy +
                                              details.delta.dy,
                                        );

                                        // Sınırları kontrol et
                                        final maxWidth =
                                            MediaQuery.of(context).size.width -
                                            140; // padding ve image width
                                        final maxHeight =
                                            MediaQuery.of(context).size.height *
                                            0.4; // container height

                                        imageItem.position = Offset(
                                          newPosition.dx.clamp(0, maxWidth),
                                          newPosition.dy.clamp(0, maxHeight),
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Transform.rotate(
                                              angle: imageItem.rotation,
                                              child: Image.network(
                                                imageItem.imageUrl,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (
                                                  context,
                                                  child,
                                                  progress,
                                                ) {
                                                  if (progress == null)
                                                    return child;
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          // Rotasyon kontrol butonu
                                          Positioned(
                                            top: 2,
                                            right: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  imageItem.rotation +=
                                                      0.785398; // 45 derece
                                                });
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.rotate_right,
                                                  size: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Silme butonu
                                          Positioned(
                                            top: 2,
                                            left: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedImages.remove(
                                                    imageItem,
                                                  );
                                                });
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              // Eğer fotoğraf varsa yardım metni
                              if (selectedImages.isNotEmpty)
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Sürükle: Taşı • Döndür: ⟲ • Sil: ✕',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                ),
              ),

              const SizedBox(height: 24),

              // 👕 Select Clothes Button
              CustomButton(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClothesSelectionPage(),
                    ),
                  );

                  if (result != null && result is ClothesSelectionResult) {
                    setState(() {
                      // Yeni seçilen fotoğrafları ekle
                      for (var imageData in result.selectedImages) {
                        selectedImages.add(
                          DraggableImageItem(
                            id: imageData.id,
                            imageUrl: imageData.imageUrl,
                            position: Offset(
                              selectedImages.length * 20.0, // Üst üste binmesin
                              selectedImages.length * 20.0,
                            ),
                            rotation: 0.0,
                          ),
                        );
                      }
                    });
                  }
                },
                text: "Select Clothes",
              ),
              const SizedBox(height: 16),

              // 💾 Save Button
              CustomButton(onTap: () {}, text: "Save"),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableImageItem {
  final String id;
  final String imageUrl;
  Offset position;
  double rotation;

  DraggableImageItem({
    required this.id,
    required this.imageUrl,
    required this.position,
    required this.rotation,
  });
}

class ClothesSelectionResult {
  final List<SelectedImageData> selectedImages;

  ClothesSelectionResult({required this.selectedImages});
}

class SelectedImageData {
  final String id;
  final String imageUrl;

  SelectedImageData({required this.id, required this.imageUrl});
}

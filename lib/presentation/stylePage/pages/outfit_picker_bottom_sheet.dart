import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
import 'package:drobee/presentation/stylePage/pages/clothes_selection.dart';
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
                                    onScaleStart: (details) {
                                      // Scale/Pan başlangıcı
                                    },
                                    onScaleUpdate: (details) {
                                      setState(() {
                                        // Eğer scale 1.0'dan farklıysa scale/rotation işlemi
                                        if (details.scale != 1.0) {
                                          // Scale değişimini yavaşlat
                                          final scaleChange =
                                              (details.scale - 1.0) *
                                              0.3; // 0.3 faktörü ile yavaşlat
                                          imageItem.scale = (imageItem.scale +
                                                  scaleChange)
                                              .clamp(0.5, 3.0);
                                          imageItem.rotation = details.rotation;
                                        }

                                        // Pan (sürükleme) işlemi
                                        final newPosition = Offset(
                                          imageItem.position.dx +
                                              details.focalPointDelta.dx,
                                          imageItem.position.dy +
                                              details.focalPointDelta.dy,
                                        );

                                        // Sınırları kontrol et
                                        final maxWidth =
                                            MediaQuery.of(context).size.width -
                                            140;
                                        final maxHeight =
                                            MediaQuery.of(context).size.height *
                                            0.4;

                                        imageItem.position = Offset(
                                          newPosition.dx.clamp(0, maxWidth),
                                          newPosition.dy.clamp(0, maxHeight),
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 100 * imageItem.scale,
                                      height: 100 * imageItem.scale,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            child: Transform.rotate(
                                              angle: imageItem.rotation,
                                              child: Image.network(
                                                imageItem.imageUrl,
                                                width: 100 * imageItem.scale,
                                                height: 100 * imageItem.scale,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
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
                              selectedImages.length * 20.0,
                              selectedImages.length * 20.0,
                            ),
                            rotation: 0.0,
                            scale: 1.0,
                          ),
                        );
                      }
                    });
                    print(result.runtimeType);
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

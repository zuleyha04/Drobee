import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/outfit_canvas.dart';
import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/outfit_picker_buttons.dart';
import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/outfit_picker_header.dart';
import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
import 'package:drobee/presentation/clothesSelection/pages/clothes_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitPickerBottomSheet extends StatefulWidget {
  const OutfitPickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<OutfitPickerBottomSheet> createState() =>
      _OutfitPickerBottomSheetState();
}

class _OutfitPickerBottomSheetState extends State<OutfitPickerBottomSheet> {
  List<DraggableImageItem> selectedImages = [];
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              OutfitPickerHeader(),
              SizedBox(height: 32.h),
              Expanded(
                child: OutfitCanvas(
                  selectedImages: selectedImages,
                  isSaving: _isSaving,
                  onImagesChanged: (images) {
                    setState(() {
                      selectedImages = images;
                    });
                  },
                ),
              ),
              SizedBox(height: 24.h),
              OutfitPickerButtons(
                isSaving: _isSaving,
                onSelectClothes: _selectClothes,
                onSaveOutfit: _saveOutfit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectClothes() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClothesSelectionPage()),
    );

    if (result != null && result is ClothesSelectionResult) {
      setState(() {
        for (var imageData in result.selectedImages) {
          selectedImages.add(
            DraggableImageItem(
              id: imageData.id,
              imageUrl: imageData.imageUrl,
              position: Offset(
                selectedImages.length * 20.0.w,
                selectedImages.length * 20.0.h,
              ),
              rotation: 0.0,
              scale: 1.0,
            ),
          );
        }
      });
    }
  }

  Future<void> _saveOutfit() async {
    if (selectedImages.isEmpty) {
      await AppFlushbar.showError(
        context,
        'Please select at least one item to save',
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      await AppFlushbar.showError(context, 'Please log in to save your outfit');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final docRef =
          FirebaseFirestore.instance.collection('user_outfits').doc();

      final outfitItemsData =
          selectedImages
              .map(
                (item) => {
                  'id': item.id,
                  'image_url': item.imageUrl,
                  'position_x': item.position.dx,
                  'position_y': item.position.dy,
                  'rotation': item.rotation,
                  'scale': item.scale,
                },
              )
              .toList();

      await docRef.set({
        'user_id': userId,
        'outfit_name':
            'My Outfit ${DateTime.now().day}/${DateTime.now().month}',
        'outfit_items': outfitItemsData,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      await AppFlushbar.showSuccess(context, 'Outfit saved successfully!');

      Navigator.pop(context, {
        'success': true,
        'outfitId': docRef.id,
        'message': 'Outfit saved successfully',
      });
    } catch (e) {
      await AppFlushbar.showSuccess(
        context,
        'Error saving outfit: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}

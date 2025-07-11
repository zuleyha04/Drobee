import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/empty_state_widget.dart';
import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/image_stack_widget.dart';
import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/save_loading_widget.dart';
import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitCanvas extends StatefulWidget {
  final List<DraggableImageItem> selectedImages;
  final bool isSaving;
  final Function(List<DraggableImageItem>) onImagesChanged;

  const OutfitCanvas({
    super.key,
    required this.selectedImages,
    required this.isSaving,
    required this.onImagesChanged,
  });

  @override
  State<OutfitCanvas> createState() => _OutfitCanvasState();
}

class _OutfitCanvasState extends State<OutfitCanvas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!, width: 1.w),
      ),
      child:
          widget.isSaving
              ? const SaveLoadingWidget()
              : widget.selectedImages.isEmpty
              ? const EmptyStateWidget()
              : ImageStackWidget(
                selectedImages: widget.selectedImages,
                onImagesChanged: widget.onImagesChanged,
              ),
    );
  }
}

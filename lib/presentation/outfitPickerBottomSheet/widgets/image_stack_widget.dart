import 'package:drobee/presentation/outfitPickerBottomSheet/widgets/draggable_image_widget.dart';
import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
import 'package:flutter/material.dart';

class ImageStackWidget extends StatefulWidget {
  final List<DraggableImageItem> selectedImages;
  final Function(List<DraggableImageItem>) onImagesChanged;

  const ImageStackWidget({
    Key? key,
    required this.selectedImages,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<ImageStackWidget> createState() => _ImageStackWidgetState();
}

class _ImageStackWidgetState extends State<ImageStackWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...widget.selectedImages.map((imageItem) {
          return DraggableImageWidget(
            imageItem: imageItem,
            onImageChanged: () {
              widget.onImagesChanged(widget.selectedImages);
            },
          );
        }).toList(),
      ],
    );
  }
}

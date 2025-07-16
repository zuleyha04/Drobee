import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DraggableImageWidget extends StatefulWidget {
  final DraggableImageItem imageItem;
  final VoidCallback onImageChanged;

  const DraggableImageWidget({
    super.key,
    required this.imageItem,
    required this.onImageChanged,
  });

  @override
  State<DraggableImageWidget> createState() => _DraggableImageWidgetState();
}

class _DraggableImageWidgetState extends State<DraggableImageWidget> {
  @override
  Widget build(BuildContext context) {
    final imageWidth = 100.w * widget.imageItem.scale;
    final imageHeight = 100.h * widget.imageItem.scale;

    return Positioned(
      left: widget.imageItem.position.dx,
      top: widget.imageItem.position.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          // Ölçek/Pan başlangıcı
        },
        onScaleUpdate: (details) {
          setState(() {
            // Ölçeklendirme
            if (details.scale != 1.0) {
              final scaleChange = (details.scale - 1.0) * 0.3;
              widget.imageItem.scale = (widget.imageItem.scale + scaleChange)
                  .clamp(0.5, 3.0);
              widget.imageItem.rotation = details.rotation;
            }

            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final imageWidth = 100.w * widget.imageItem.scale;
            final imageHeight = 100.h * widget.imageItem.scale;

            final newPosition = Offset(
              widget.imageItem.position.dx + details.focalPointDelta.dx,
              widget.imageItem.position.dy + details.focalPointDelta.dy,
            );

            final minX = -imageWidth / 2;
            final maxX = screenWidth - imageWidth * 0.25;
            final minY = -imageHeight / 2;
            final maxY = screenHeight * 0.5 - imageHeight / 2;

            widget.imageItem.position = Offset(
              newPosition.dx.clamp(minX, maxX),
              newPosition.dy.clamp(minY, maxY),
            );
          });

          widget.onImageChanged();
        },
        child: Container(
          width: imageWidth,
          height: imageHeight,
          child: Stack(
            children: [
              ClipRRect(
                child: Transform.rotate(
                  angle: widget.imageItem.rotation,
                  child: Image.network(
                    widget.imageItem.imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.grey),
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
  }
}

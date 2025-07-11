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
    return Positioned(
      left: widget.imageItem.position.dx,
      top: widget.imageItem.position.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          // Scale/Pan başlangıcı
        },
        onScaleUpdate: (details) {
          setState(() {
            if (details.scale != 1.0) {
              final scaleChange = (details.scale - 1.0) * 0.3;
              widget.imageItem.scale = (widget.imageItem.scale + scaleChange)
                  .clamp(0.5, 3.0);
              widget.imageItem.rotation = details.rotation;
            }

            final newPosition = Offset(
              widget.imageItem.position.dx + details.focalPointDelta.dx,
              widget.imageItem.position.dy + details.focalPointDelta.dy,
            );

            final maxWidth = MediaQuery.of(context).size.width - 140.w;
            final maxHeight = MediaQuery.of(context).size.height * 0.4;

            widget.imageItem.position = Offset(
              newPosition.dx.clamp(0, maxWidth),
              newPosition.dy.clamp(0, maxHeight),
            );
          });
          widget.onImageChanged();
        },
        child: Container(
          width: 100.w * widget.imageItem.scale,
          height: 100.h * widget.imageItem.scale,
          child: Stack(
            children: [
              ClipRRect(
                child: Transform.rotate(
                  angle: widget.imageItem.rotation,
                  child: Image.network(
                    widget.imageItem.imageUrl,
                    width: 100.w * widget.imageItem.scale,
                    height: 100.h * widget.imageItem.scale,
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

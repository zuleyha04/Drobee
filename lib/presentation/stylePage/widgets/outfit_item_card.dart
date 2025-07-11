import 'package:drobee/presentation/stylePage/widgets/outfit_detail_dialog.dart';
import 'package:drobee/presentation/stylePage/widgets/outfit_delete_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitItemCard extends StatelessWidget {
  final Map<String, dynamic> outfit;

  const OutfitItemCard({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    final outfitItems = outfit['outfit_items'] as List<dynamic>? ?? [];

    return GestureDetector(
      onTap: () {
        _showOutfitPreview(context, outfit);
      },
      onLongPress: () {
        _deleteOutfit(context, outfit['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!, width: 1.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              // Outfit öğelerini göster
              ...outfitItems.map((item) {
                final itemMap = item as Map<String, dynamic>;
                final imageUrl = itemMap['image_url'] as String? ?? '';
                final positionX =
                    (itemMap['position_x'] as num?)?.toDouble() ?? 0.0;
                final positionY =
                    (itemMap['position_y'] as num?)?.toDouble() ?? 0.0;
                final scale = (itemMap['scale'] as num?)?.toDouble() ?? 1.0;
                final rotation =
                    (itemMap['rotation'] as num?)?.toDouble() ?? 0.0;

                return Positioned(
                  left: positionX * 0.4,
                  top: positionY * 0.4,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Container(
                      width: 60.w * scale,
                      height: 60.h * scale,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.error,
                                color: Colors.grey,
                                size: 30.sp,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showOutfitPreview(BuildContext context, Map<String, dynamic> outfit) {
    showDialog(
      context: context,
      builder: (context) => OutfitDetailDialog(outfit: outfit),
    );
  }

  void _deleteOutfit(BuildContext context, String outfitId) {
    showDialog(
      context: context,
      builder: (context) => OutfitDeleteConfirmation(outfitId: outfitId),
    );
  }
}

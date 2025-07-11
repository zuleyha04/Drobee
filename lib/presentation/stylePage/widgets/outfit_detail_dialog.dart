import 'package:drobee/presentation/stylePage/widgets/outfit_delete_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitDetailDialog extends StatelessWidget {
  final Map<String, dynamic> outfit;

  const OutfitDetailDialog({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    final outfitItems = outfit['outfit_items'] as List<dynamic>? ?? [];
    final outfitName = outfit['outfit_name'] as String? ?? 'Unnamed Outfit';
    final outfitId = outfit['id'] as String? ?? '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 300.w,
        height: 400.h,
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Text(
              outfitName,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    ...outfitItems.map((item) {
                      final itemMap = item as Map<String, dynamic>;
                      final imageUrl = itemMap['image_url'] as String? ?? '';
                      final positionX =
                          (itemMap['position_x'] as num?)?.toDouble() ?? 0.0;
                      final positionY =
                          (itemMap['position_y'] as num?)?.toDouble() ?? 0.0;
                      final scale =
                          (itemMap['scale'] as num?)?.toDouble() ?? 1.0;
                      final rotation =
                          (itemMap['rotation'] as num?)?.toDouble() ?? 0.0;

                      return Positioned(
                        left: positionX * 0.7,
                        top: positionY * 0.7,
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
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Önce dialog'u kapat
                    _deleteOutfit(
                      context,
                      outfitId,
                    ); // Sonra silme işlemini başlat
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteOutfit(BuildContext context, String outfitId) {
    showDialog(
      context: context,
      builder: (context) => OutfitDeleteConfirmation(outfitId: outfitId),
    );
  }
}

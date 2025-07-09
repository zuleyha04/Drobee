import 'package:drobee/presentation/stylePage/widgets/outfit_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitGridView extends StatelessWidget {
  final List<Map<String, dynamic>> outfits;

  const OutfitGridView({Key? key, required this.outfits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 16.h, bottom: 0),

      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.0,
        ),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          return OutfitItemCard(outfit: outfit);
        },
      ),
    );
  }
}

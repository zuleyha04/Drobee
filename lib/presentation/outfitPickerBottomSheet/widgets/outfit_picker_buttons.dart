import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutfitPickerButtons extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSelectClothes;
  final VoidCallback onSaveOutfit;

  const OutfitPickerButtons({
    Key? key,
    required this.isSaving,
    required this.onSelectClothes,
    required this.onSaveOutfit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          onTap: isSaving ? () {} : onSelectClothes,
          text: "Select Clothes",
        ),
        SizedBox(height: 16.h),
        CustomButton(onTap: isSaving ? () {} : onSaveOutfit, text: "Save"),
        SizedBox(height: 16.h),
      ],
    );
  }
}

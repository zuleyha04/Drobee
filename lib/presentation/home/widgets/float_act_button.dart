import 'package:drobee/presentation/addBottomSheet/pages/add_bottom_sheet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFloatingActionButton extends StatelessWidget {
  const AddFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home_tag',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PhotoPickerBottomSheet(),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 8,
      child: Icon(Icons.add, color: Colors.white, size: 28.sp),
    );
  }
}

import 'package:drobee/presentation/addBottomSheet/widgets/photo_picker_box.dart';
import 'package:flutter/material.dart';

class AddBottomSheetPage extends StatelessWidget {
  const AddBottomSheetPage({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddBottomSheetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PhotoPickerBottomSheet(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:drobee/presentation/addBottomSheet/pages/add_bottom_sheet_page.dart';

class AddFloatingActionButton extends StatelessWidget {
  const AddFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PhotoPickerBox(),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 8,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/data/services/firestore_database_service.dart';
import 'package:flutter/material.dart';

class OutfitDeleteConfirmation extends StatelessWidget {
  final String outfitId;

  const OutfitDeleteConfirmation({super.key, required this.outfitId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Outfit'),
      content: const Text('Are you sure you want to delete this outfit?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await FirestoreService.deleteOutfit(outfitId);
              await AppFlushbar.showSuccess(
                context,
                'Outfit deleted successfully',
              );
            } catch (e) {
              await AppFlushbar.showError(context, 'Error deleting outfit: $e');
            }
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

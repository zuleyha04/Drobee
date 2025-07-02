import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/data/services/firestore_database_service.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({super.key});

  Future<void> _confirmAndDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
              'Are you sure you want to permanently delete your account ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await FirestoreService.deleteCurrentUser();

        if (context.mounted) {
          AppNavigator.pushReplacement(context, OnBoardingPage(initialPage: 3));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          AppFlushbar.showError(
            context,
            'Please log in again before deleting your account.',
          );
        } else {
          AppFlushbar.showError(
            context,
            'Account deletion failed: ${e.message}',
          );
        }
      } catch (e) {
        AppFlushbar.showError(context, 'Unexpected error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
      onTap: () => _confirmAndDeleteAccount(context),
    );
  }
}

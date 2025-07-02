import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () async {
        await FirebaseAuth.instance.signOut();

        if (context.mounted) {
          AppNavigator.pushReplacement(context, OnBoardingPage(initialPage: 3));
        }
      },
    );
  }
}

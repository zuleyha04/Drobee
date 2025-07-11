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
          // 🔐 Yönlendirme yapmadan önce animasyonlara zaman tanı!
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder:
                    (_, __, ___) => const OnBoardingPage(initialPage: 3),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          });
        }
      },
    );
  }
}

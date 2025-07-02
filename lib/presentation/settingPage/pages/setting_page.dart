import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:drobee/presentation/settingPage/widgets/delete_account_tile.dart';
import 'package:drobee/presentation/settingPage/widgets/logout_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const PageTitle('Settings'),
              const SizedBox(height: 24),
              if (user != null) ...[
                Text(
                  user.email ?? 'No email',
                  style: const TextStyle(fontSize: 18),
                ),
                const Divider(height: 32),
              ],
              const LogoutTile(),
              const DeleteAccountTile(),
              const Divider(height: 32),
              Text(' - Version 1.0.0 -'),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:drobee/presentation/settingPage/widgets/delete_account_tile.dart';
import 'package:drobee/presentation/settingPage/widgets/logout_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              const PageTitle('Settings'),
              SizedBox(height: 24.h),
              if (user != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                  ),
                  child: Text(
                    user.email ?? 'No email',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                Divider(height: 32.h),
              ],

              const LogoutTile(),
              const DeleteAccountTile(),
              Divider(height: 32.h),
              Text(' - Version 1.0.0 -'),
            ],
          ),
        ),
      ),
    );
  }
}

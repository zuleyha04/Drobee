import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/presentation/addBottomSheet/pages/add_bottom_sheet_page.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFloatingActionButton extends StatelessWidget {
  const AddFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final todayCount = state.todayImages.length;
        final limitReached = todayCount >= 3;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'home_tag',
              onPressed: () {
                if (limitReached) {
                  AppFlushbar.showError(
                    context,
                    'You have reached your daily upload limit. Please try again tomorrow.',
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const PhotoPickerBottomSheet(),
                  );
                }
              },
              backgroundColor:
                  limitReached ? Colors.grey : Theme.of(context).primaryColor,
              elevation: 8,
              child: Icon(Icons.add, color: Colors.white, size: 28.sp),
            ),
          ],
        );
      },
    );
  }
}

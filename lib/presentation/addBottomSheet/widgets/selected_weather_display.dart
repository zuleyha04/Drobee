import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Eklendi

class SelectedWeatherDisplay extends StatelessWidget {
  const SelectedWeatherDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWeathers = context.select(
      (PhotoPickerCubit cubit) => cubit.state.selectedWeathers,
    );

    if (selectedWeathers.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seçilen Hava Durumları:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children:
                selectedWeathers.map((weather) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      weather,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

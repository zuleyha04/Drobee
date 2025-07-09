import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotoPickerCubit, PhotoPickerState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!context.mounted) return;

            AppFlushbar.showSuccess(context, state.successMessage!);
            context.read<PhotoPickerCubit>().clearMessages();

            await Future.delayed(Duration(seconds: 3));

            if (!context.mounted) return;
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
        }

        if (state.error != null) {
          Future.delayed(Duration.zero, () {
            AppFlushbar.showError(context, state.error!);
            context.read<PhotoPickerCubit>().clearMessages();
          });
        }
      },
      child: BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.isProcessing)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Removing background...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

              if (state.selectedWeathers.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Weather Conditions:',
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
                            state.selectedWeathers.map((weather) {
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

              if (state.isUploading)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Uploading image and saving to database...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

              CustomButton(
                onTap:
                    state.hasAnyLoading
                        ? () {}
                        : () {
                          context
                              .read<PhotoPickerCubit>()
                              .savePhotoWithWeathers();
                        },
                text: 'Save',
              ),
            ],
          );
        },
      ),
    );
  }
}

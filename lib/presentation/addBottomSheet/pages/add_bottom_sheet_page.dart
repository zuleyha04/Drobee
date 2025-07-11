import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:drobee/presentation/addBottomSheet/pages/photo_picker_actions.dart';
import 'package:drobee/presentation/addBottomSheet/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/addBottomSheet/widgets/weather_chips.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoPickerBottomSheet extends StatelessWidget {
  const PhotoPickerBottomSheet({super.key});

  static const List<String> _weatherOptions = [
    "Sunny",
    "Cloudy",
    "Rainy",
    "Snowy",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoPickerCubit(),
      child: BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        _buildPhotoArea(state, context),
                        SizedBox(height: 16.h),
                        const PhotoPickerActions(),
                        SizedBox(height: 16.h),
                        const WeatherChips(options: _weatherOptions),
                        SizedBox(height: 20.h),
                        const SaveButton(),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Your Items",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea(PhotoPickerState state, BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(child: _buildPhotoContent(state, context)),
      ),
    );
  }

  Widget _buildPhotoContent(PhotoPickerState state, BuildContext context) {
    if (state.isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          const Text('Loading image...'),
        ],
      );
    }

    if (state.isProcessing) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          const Text('Removing background...'),
        ],
      );
    }

    if (state.displayImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              state.displayImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () {
                context.read<PhotoPickerCubit>().removeImage();
              },
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.image_outlined, size: 48.sp, color: Colors.grey.shade500),
        SizedBox(height: 10.h),
        Text(
          "Add Photo",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
